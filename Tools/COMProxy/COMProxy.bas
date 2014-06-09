Attribute VB_Name = "COMProxy"
Option Explicit
Option Base 0

Public Const APP_REG_KEY = "HKLM\Software\OW\"
Public Const LOCAL_TEMP_DIR = APP_REG_KEY & "LOCAL_TEMP_DIR" ' Local dir for temp files
Public Const WebService = APP_REG_KEY & "WebService" ' Local dir for temp files
Public Const WEB_SERVER As String = APP_REG_KEY & "WebServer"
Public Const WEB_VIRTUAL_DIRECTORY = APP_REG_KEY & "VirtualDirectory"


Const BASE_SOAP_ACTION_URI As String = "http://tempuri.org/"
Const WRAPPER_ELEMENT_NAMESPACE As String = "http://tempuri.org/message/"


Public Enum enumEntityType
    EntityTypeDestiny = 0
    EntityTypeOrigin = 1
End Enum


' Role types
Public Enum ROLE_TYPE
    ROLE_NONE = 1 ' User has no role
    ROLE_USER = 2 ' Normal user
    ' registry roles
    ROLE_SEARCH = 3 ' user can search
    ROLE_INSERT = 4 ' user can insert
    ROLE_CLASSIFY = 5 ' user can ONLY change classification and observations
    ROLE_MODIFY = 6 ' user can modify
    ROLE_ADMIN = 7 ' Administrator
End Enum

Public Type stGroup
    Description As String
    GroupID As Long
End Type


Public Type stEntity
    Name As String
    ConnectID As String
    Type As enumEntityType
End Type


Public Type stBook
    BookID As String
    Name As String
    Abreviation As String
End Type


Public Type stDocumentType
    DocumentTypeID As String
    DocumentTypeAbreviation As String
    DocumentTypeDescription As String
End Type

Public Type stClassification
    Level1Abreviation As String
    Level2Abreviation As String
    Level3Abreviation As String
    Level4Abreviation As String
    Level5Abreviation As String
End Type

Public Type stList
    ListID As String
    Description As String
End Type

Public Type stContact
    ContactID As String
    FieldID As Long
    FieldValue As String
End Type

Public Type stFieldsStruct
    FieldID As Long
    FieldType As String
    FieldValue As String
End Type

Public Type stDynamicFieldsStruct
    DynamicFieldID As Long
    DynamicFieldType As String
    DynamicFieldName As String
    DynamicFieldValue As String
End Type

Public Type stItem
    Identifier As Long
    Value As String
    Other As String
End Type

Public Enum enumAddressRoles
    Search = 2 ' user can search
    Modify = 4 ' user can modify
    Manage = 7 ' user can manage
    Count = Manage ' num of roles
End Enum

' Field types
Public Const FIELDS_TYPE_STRING = "FieldTypeString"
Public Const FIELDS_TYPE_NUMERIC = "FieldTypeNumeric"
Public Const FIELDS_TYPE_FLOAT = "FieldTypeFloat"
Public Const FIELDS_TYPE_DATE = "FieldTypeDate"
Public Const FIELDS_TYPE_DATETIME = "FieldTypeDateTime"
Public Const FIELDS_TYPE_TEXT = "FieldTypeText"
Public Const FIELDS_TYPE_SET = "FieldTypeSet"
Public Const FIELDS_TYPE_BOOLEAN = "FieldTypeBoolean"
Public Const FIELDS_TYPE_LIST = "FieldTypeList"

''Contact role type
Public Const CONTACT_ROLE_TYPE_SEARCH = "Search"
Public Const CONTACT_ROLE_TYPE_MODIFY = "Modify"
Public Const CONTACT_ROLE_TYPE_MANAGE = "Manage"
Public Const CONTACT_ROLE_TYPE_COUNT = "Count"

''Access Types
Public Const ACCESS_TYPE_USER = "User"
Public Const ACCESS_TYPE_GROUP = "Group"


Public Enum enumAddressesFieldID
    enumFieldIDNone = -1
    enumFieldIDName = 0
    enumFieldIDEntID = 1
    enumFieldIDFirstName = 2
    enumFieldIDMiddleName = 3
    enumFieldIDLastName = 4
    enumFieldIDBI = 5
    enumFieldIDNumContribuinte = 6
    enumFieldIDAssociateNum = 7
    enumFieldIDeMail = 8
    enumFieldIDJobTitle = 9
    enumFieldIDStreet = 10
    enumFieldIDPostalCodeID = 11
    enumFieldIDDistrictID = 12
    enumFieldIDCountryID = 13
    enumFieldIDPhone = 14
    enumFieldIDFax = 15
    enumFieldIDMobile = 16
    enumFieldIDListID = 17
    enumFieldIDEntityID = 18
    enumFieldIDEntityName = 19
    enumFieldIDActive = 20
End Enum



Public gsWebServer As String
Public gsVirtualDirectory As String
Public gsWebService As String


'**************************** GetWebServer ******************************
' DESCRIPTION: Get Web server Name
' RECEIVES   :
' RETURNS    : Web server Name
Public Function GetWebServer() As String
On Error GoTo GetWebServerErr
    Dim objWSH As Object
   
    'return if already exists
    If Len(Trim(gsWebServer)) > 0 Then
        GetWebServer = gsWebServer
        Exit Function
    End If
   
    ' Read fileserver location from registry
    Set objWSH = CreateObject("WScript.Shell")
    gsWebServer = objWSH.RegRead(WEB_SERVER)
    GetWebServer = gsWebServer
    
    
    ' Do some cleanup
    Set objWSH = Nothing
    Exit Function
    
GetWebServerErr:
    'Err.Raise Err.Number, Err.Source, Err.Description
       
End Function


'**************************** GetTempDir ******************************
' DESCRIPTION: Get temporary directory
' RECEIVES   :
' RETURNS    : Temporary directory path
Public Function GetTempDir() As String
On Error GoTo ErrSub
    Dim objWSH As Object
   
    ' Read fileserver location from registry
    Set objWSH = CreateObject("WScript.Shell")
    GetTempDir = objWSH.RegRead(LOCAL_TEMP_DIR)
    
    
    ' Do some cleanup
    Set objWSH = Nothing
    Exit Function
    
ErrSub:
        GetTempDir = ""
       Err.Raise Err.Number, Err.Source, Err.Description
End Function


'**************************** GetVirtualDirectory ******************************
' DESCRIPTION: Get OfficeWorks virtual directory
' RECEIVES   :
' RETURNS    : OfficeWorks virtual directory
Public Function GetVirtualDirectory() As String
On Error GoTo ErrSub
    Dim objWSH As Object
   
   'return if already exists
    If Len(Trim(gsVirtualDirectory)) > 0 Then
        GetVirtualDirectory = gsVirtualDirectory
        Exit Function
    End If
   
    ' Read fileserver location from registry
    Set objWSH = CreateObject("WScript.Shell")
    gsVirtualDirectory = objWSH.RegRead(WEB_VIRTUAL_DIRECTORY)
    GetVirtualDirectory = gsVirtualDirectory
    
    
    ' Do some cleanup
    Set objWSH = Nothing
    Exit Function
    
ErrSub:
       'Err.Raise Err.Number, Err.Source, Err.Description
End Function




'*************************** GetUserName *********************************
' DESCRIPTION: Get user name
' RECEIVES   :
' NOTE       : For windows 98 compatibility:
'              if environement variable USERDOMAIN not defined
'              WshNetwork.UserDomain returns an empty string
'              In this case the function gets the webserver domain
Public Function GetUserName() As String
On Error GoTo ErrSub
Dim WshNetwork As Object
Dim oRoot As Object

Set WshNetwork = CreateObject("WScript.Network")
GetUserName = WshNetwork.UserDomain

' If WshNetwork.UserDomain returns nothing => windows 98 fix
If Trim(GetUserName) = "" Then
    Set oRoot = GetObject("WinNT://" & GetWebServer())
    GetUserName = oRoot.Parent
    GetUserName = Replace(GetUserName, "WinNT://", "", 1, -1, vbTextCompare)
End If

GetUserName = GetUserName & "\" & WshNetwork.UserName

ExitSub:
    Set WshNetwork = Nothing
    Exit Function
ErrSub:
    GetUserName = ""
    Err.Raise Err.Number, Err.Source, Err.Description
    Resume ExitSub
End Function



'**************************** GetWebService ******************************
' DESCRIPTION: Get Web Service
' RECEIVES   :
' RETURNS    : The Web Service
Public Function GetWebService() As String
On Error GoTo GetWebServiceErr
    Dim objWSH As Object
   
    'return if already exists
    If Len(Trim(gsWebService)) > 0 Then
        GetWebService = gsWebService
        Exit Function
    End If
    
    ' Read fileserver location from registry
    Set objWSH = CreateObject("WScript.Shell")
    gsWebService = objWSH.RegRead(WebService)
    GetWebService = gsWebService
    
    ' Do some cleanup
    Set objWSH = Nothing
    Exit Function
    
GetWebServiceErr:
       'Err.Raise Err.Number, Err.Source, Err.Description
End Function


' FUNCTION: Remove invalid characters from a file name
Public Function IsFileNameValid(ByVal RealFileName As String) As Boolean
On Error GoTo ErrSub


If InStr(0, RealFileName, ":") > 0 Or _
  InStr(0, RealFileName, ":") > 0 Or _
 InStr(0, RealFileName, "/") > 0 Or _
 InStr(0, RealFileName, "\") > 0 Or _
 InStr(0, RealFileName, "*") > 0 Or _
 InStr(0, RealFileName, "?") > 0 Or _
 InStr(0, RealFileName, """") > 0 Or _
 InStr(0, RealFileName, "<") > 0 Or _
 InStr(0, RealFileName, ">") > 0 Or _
 InStr(0, RealFileName, "|") > 0 Then
    IsFileNameValid = False
Else
    IsFileNameValid = True
End If


ExitSub:
   
Exit Function
ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
End Function



' FUNCTION: Remove invalid characters from a file name
Private Function RemoveInvalidChars(ByVal RealFileName As String) As String
On Error GoTo ErrSub

RealFileName = Replace(RealFileName, ":", " ")
RealFileName = Replace(RealFileName, "/", " ")
RealFileName = Replace(RealFileName, "\", " ")
RealFileName = Replace(RealFileName, "*", " ")
RealFileName = Replace(RealFileName, "?", " ")
RealFileName = Replace(RealFileName, """", " ")
RealFileName = Replace(RealFileName, "<", " ")
RealFileName = Replace(RealFileName, ">", " ")
RealFileName = Replace(RealFileName, "|", " ")

RemoveInvalidChars = RealFileName

ExitSub:
   
Exit Function
ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    RemoveInvalidChars = ""
End Function


Private Function ConvertEntToString(ByRef EntType As enumEntityType) As String
On Error GoTo ErrSub

If EntType = EntityTypeDestiny Then
    ConvertEntToString = "EntityTypeDestiny"
Else
    ConvertEntToString = "EntityTypeOrigin"
End If

ExitSub:
    Exit Function
ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
Resume ExitSub
End Function

Private Function ConvertDateToString(ValueDate As Date) As String
On Error GoTo ErrSub

    Dim DateYear As Long
    Dim DateMonth As Long
    Dim DateDay As Long

    DateYear = Year(ValueDate)
    DateMonth = Month(ValueDate)
    DateDay = Day(ValueDate)

    If CLng(ValueDate) = 0 Then
        ConvertDateToString = "0001-01-01T00:00:00.0000000-00:00"
    Else
        ConvertDateToString = CStr(DateYear) & IIf(DateMonth < 10, "-0", "-") & CStr(DateMonth) & IIf(DateDay < 10, "-0", "-") & CStr(DateDay) & "T00:00:00.0000000+00:00"
    End If


ExitSub:
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
Resume ExitSub
End Function

Private Sub ConvertStringToUTF8(serializer As MSSOAPLib30.SoapSerializer30, ValueString As String)
On Error GoTo ErrSub

    Dim i As Long
    Dim code As Long
    Dim char As String
    Dim strOut As String
    Dim CharValue As String
    Dim SoapValue As String

    Dim byteIndex As Long
    Dim byteValue() As Byte

    byteIndex = 0
    ReDim byteValue(Len(ValueString) * 2)

    CharValue = "ÀÁÂÃÄÇÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜàáâãäçèéêëìíîïòóôõöùúûü&"
    SoapValue = ""
    SoapValue = SoapValue & Chr(&H80) & Chr(&H81) & Chr(&H82) & Chr(&H83) & Chr(&H84) ' ÀÁÂÃÄ
    SoapValue = SoapValue & Chr(&H87)                                                 ' Ç
    SoapValue = SoapValue & Chr(&H88) & Chr(&H89) & Chr(&H8A) & Chr(&H8B)             ' ÈÉÊË
    SoapValue = SoapValue & Chr(&H8C) & Chr(&H8D) & Chr(&H8E) & Chr(&H8F)             ' ÌÍÎÏ
    SoapValue = SoapValue & Chr(&H92) & Chr(&H93) & Chr(&H94) & Chr(&H95) & Chr(&H96) ' ÒÓÔÕÖ
    SoapValue = SoapValue & Chr(&H99) & Chr(&H9A) & Chr(&H9B) & Chr(&H9C)             ' ÙÚÛÜ
    SoapValue = SoapValue & Chr(&HA0) & Chr(&HA1) & Chr(&HA2) & Chr(&HA3) & Chr(&HA4) ' àáâãä
    SoapValue = SoapValue & Chr(&HA7)                                                 ' ç
    SoapValue = SoapValue & Chr(&HA8) & Chr(&HA9) & Chr(&HAA) & Chr(&HAB)             ' èéêë
    SoapValue = SoapValue & Chr(&HAC) & Chr(&HAD) & Chr(&HAE) & Chr(&HAF)             ' ìíîï
    SoapValue = SoapValue & Chr(&HB2) & Chr(&HB3) & Chr(&HB4) & Chr(&HB5) & Chr(&HB6) ' òóôõö
    SoapValue = SoapValue & Chr(&HB9) & Chr(&HBA) & Chr(&HBB) & Chr(&HBC)             ' ùúûü
    SoapValue = SoapValue & Chr(&H26)                                                 ' &


    For i = 1 To Len(ValueString)
        char = Mid(ValueString, i, 1)
        code = InStr(1, CharValue, char, vbBinaryCompare)
        If code > 0 Then
            byteValue(byteIndex) = &HC3
            byteIndex = byteIndex + 1
            byteValue(byteIndex) = CByte(Asc(Mid(SoapValue, code, 1)))
        Else
            byteValue(byteIndex) = CByte(Asc(char))
        End If
        byteIndex = byteIndex + 1
    Next i
    serializer.WriteBuffer byteIndex, byteValue(0)

ExitSub:
    Exit Sub

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
Resume ExitSub
End Sub

' See ConvertStringToWebService in OfficeWorks.Global.Generic of OWCommonModule Assembly for algoritm explanation
Private Sub ConvertStringToWebService(serializer As MSSOAPLib30.SoapSerializer30, ValueString As String)
On Error GoTo ErrSub

    Dim i As Long
    Dim code As Long
    Dim char As String
    Dim strOut As String
    Dim CharValue As String
    Dim SoapValue As String

    Dim byteIndex As Long
    Dim byteValue() As Byte

    byteIndex = 0
    ReDim byteValue(Len(ValueString) * 3)

    For i = 1 To Len(ValueString)
        char = Mid(ValueString, i, 1)
        code = Asc(char)
        If code > &H7F Then
            byteValue(byteIndex) = &H7F
            byteIndex = byteIndex + 1
            byteValue(byteIndex) = code - &H80
        ElseIf code >= &H21 And code <= &H2F Then '  If it is the & character ' 21 e 2F   H26 =>&
                byteValue(byteIndex) = &H7F
                byteIndex = byteIndex + 1
                byteValue(byteIndex) = &H7F
                byteIndex = byteIndex + 1
                byteValue(byteIndex) = code + 32
            Else
                byteValue(byteIndex) = CByte(Asc(char))
        End If
            
        byteIndex = byteIndex + 1
    Next i
    serializer.WriteBuffer byteIndex, byteValue(0)

ExitSub:
    Exit Sub

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
Resume ExitSub
End Sub


' ONLY USES: Book Abreviation, DocumentTypeAbreviation and entity name
' OtherEntities(0)="" if no entities wanted
' RETURNS  : 0 -> If error
'            regid otherwise
Public Function ExecuteWebMethod(ByVal EndPointURL As String, _
                                 ByVal DomainAndUsername As String, _
                                 ByVal Password As String, _
                                 ByVal Method As String, _
                                 ByVal RegYear As String, _
                                 ByVal RegDate As Date, _
                                 ByVal DocDate As Date, _
                                 ByRef Book As stBook, _
                                 ByVal Subject As String, _
                                 ByVal Observations As String, _
                                 ByRef DocumentType As stDocumentType, _
                                 ByRef MainEntity As stEntity, _
                                 ByRef OtherEntities() As stEntity, _
                                 ByVal RealFileName As String, _
                                 ByVal PostFilePathName As String, _
                                 ByRef Classification As stClassification, _
                                 Optional ByVal Reference As String = "", _
                                 Optional ByVal RegNumber As String) As String
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim Composer As New MSSOAPLib30.DimeComposer30
    Dim Ent As stEntity
    Dim i As Integer
    Dim aLBound As Integer
    Dim aUBound As Integer
    
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & Method
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'Serializer.Init Connector.InputStream
    serializer.InitWithComposer Connector.InputStream, Composer
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<InsertRegistry xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    'Domain and user name
    serializer.WriteXml "<strDomainAndUsername>" & DomainAndUsername & "</strDomainAndUsername>"
    ' Password
    serializer.WriteXml "<strPassword>" & Password & "</strPassword>"
    ' Registry
    serializer.WriteXml "<Registry>"
    ' Book
    serializer.WriteXml "<Book>"
        serializer.WriteXml "<BookAbreviation>" & Book.Abreviation & "</BookAbreviation>"
    serializer.WriteXml "</Book>"
    ' Year
    serializer.WriteXml "<Year>" & RegYear & "</Year>"
    ' Number
    If Trim(RegNumber) <> "" Then
        serializer.WriteXml "<Number>" & Trim(RegNumber) & "</Number>"
    End If
    ' Register Date
    serializer.WriteXml "<RegistryDate>" & ConvertDateToString(RegDate) & "</RegistryDate>"
    ' Subject
    serializer.WriteXml "<Subject>"
        ConvertStringToWebService serializer, Subject
    serializer.WriteXml "</Subject>"
    ' Observs
    serializer.WriteXml "<Observations>"
        ConvertStringToWebService serializer, Observations
    serializer.WriteXml "</Observations>"
    ' Referência
    serializer.WriteXml "<Reference>"
        ConvertStringToWebService serializer, Reference
    serializer.WriteXml "</Reference>"
    ' Document Type
    serializer.WriteXml "<DocumentType>"
        serializer.WriteXml "<DocumentTypeID>0</DocumentTypeID>"
        serializer.WriteXml "<DocumentTypeAbreviation>" & DocumentType.DocumentTypeAbreviation & "</DocumentTypeAbreviation>"
        serializer.WriteXml "<DocumentTypeDescription></DocumentTypeDescription>"
    serializer.WriteXml "</DocumentType>"
    ' Document Date
    serializer.WriteXml "<DocumentDate>" & ConvertDateToString(DocDate) & "</DocumentDate>"
    'Classification
    If Classification.Level1Abreviation <> "" Then
        serializer.WriteXml "<Classification>"
            serializer.WriteXml "<ClassificationID>0</ClassificationID>"
            serializer.WriteXml "<Level1Abreviation>" & Classification.Level1Abreviation & "</Level1Abreviation>"
            serializer.WriteXml "<Level1Description></Level1Description>"
            serializer.WriteXml "<Level2Abreviation>" & Classification.Level2Abreviation & "</Level2Abreviation>"
            serializer.WriteXml "<Level2Description></Level2Description>"
            serializer.WriteXml "<Level3Abreviation>" & Classification.Level3Abreviation & "</Level3Abreviation>"
            serializer.WriteXml "<Level3Description></Level3Description>"
            serializer.WriteXml "<Level4Abreviation>" & Classification.Level4Abreviation & "</Level4Abreviation>"
            serializer.WriteXml "<Level4Description></Level4Description>"
            serializer.WriteXml "<Level5Abreviation>" & Classification.Level5Abreviation & "</Level5Abreviation>"
            serializer.WriteXml "<Level5Description></Level5Description>"
        serializer.WriteXml "</Classification>"
    End If
    ' Entity
    serializer.WriteXml "<Entity>"
        serializer.WriteXml "<EntityID>" & MainEntity.ConnectID & "</EntityID>"
        serializer.WriteXml "<EntityName>"
            ConvertStringToWebService serializer, MainEntity.Name
        serializer.WriteXml "</EntityName>"
        serializer.WriteXml "<EntityExchangeID></EntityExchangeID>"
    serializer.WriteXml "</Entity>"
    ' More Entities
    If OtherEntities(0).ConnectID > 0 Then
        aLBound = LBound(OtherEntities)
        aUBound = UBound(OtherEntities)
        serializer.WriteXml "<MoreEntities>"
        For i = aLBound To aUBound
            Ent = OtherEntities(i)
            If Ent.ConnectID > 0 Then
                serializer.WriteXml "<stEntity>"
                    serializer.WriteXml "<EntityID>" & Ent.ConnectID & "</EntityID>"
                    serializer.WriteXml "<EntityName>"
                        ConvertStringToWebService serializer, Ent.Name
                    serializer.WriteXml "</EntityName>"
                    serializer.WriteXml "<EntityExchangeID></EntityExchangeID>"
                    serializer.WriteXml "<EntityType>" & ConvertEntToString(Ent.Type) & "</EntityType>"
               serializer.WriteXml "</stEntity>"
            End If
        Next
        serializer.WriteXml "</MoreEntities>"
    End If

    ' ********************************************************
    ' ****************** FILES START *************************
    ' ********************************************************
    Dim FileAttach As New MSSOAPLib30.FileAttachment30

    FileAttach.FileName = PostFilePathName
    'FileAttach.Property("DimeTNF") = "media-type"
    'FileAttach.Property("DimeType") = "application/pdf"
    FileAttach.Property("DimeID") = RemoveInvalidChars(RealFileName)
    serializer.AddAttachment FileAttach

    ' ******************************************************
    ' ****************** FILES END *************************
    ' ******************************************************
    
    ' User
    serializer.WriteXml "<User>"
        serializer.WriteXml "<UserLogin>" & DomainAndUsername & "</UserLogin>"
    serializer.WriteXml "</User>"
    
    serializer.WriteXml "</Registry>"
    serializer.WriteXml "</InsertRegistry>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    ' "Registo Não inserido..."
    If Not Reader.Fault Is Nothing Then
        ' MsgBox Reader.FaultString.Text
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
        ExecuteWebMethod = 0
    Else
        ' Registo Não inserido...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao inserir no OfficeWorks"
            ExecuteWebMethod = 0
        Else
            ' "Registo inserido com sucesso..."
            ExecuteWebMethod = Reader.RpcResult.Text
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Function


' ONLY USES: Book Abreviation, DocumentTypeAbreviation and entity name
' OtherEntities(0)="" if no entities wanted
' RETURNS  : 0 -> If error
'            regid otherwise
Public Function ExecuteWebMethodEx(ByVal EndPointURL As String, _
                                    ByVal DomainAndUsername As String, _
                                    ByVal Password As String, _
                                    ByVal Method As String, _
                                    ByVal RegYear As String, _
                                    ByVal RegDate As Date, _
                                    ByVal DocDate As Date, _
                                    ByRef Book As stBook, _
                                    ByRef DocumentType As stDocumentType, _
                                    ByRef MainEntity As stEntity, _
                                    ByRef OtherEntities() As stEntity, _
                                    ByRef DynamicFields() As stDynamicFieldsStruct, _
                                    ByRef Classification As stClassification, _
                                    ByVal RealFileName As String, _
                                    ByVal PostFilePathName As String, _
                                    ByVal RegNumber As String, _
                                    Optional ByVal Subject As String = "", _
                                    Optional ByVal Reference As String = "", _
                                    Optional ByVal Process As String = "", _
                                    Optional ByVal Observations As String = "") As String

    On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim Composer As New MSSOAPLib30.DimeComposer30
    Dim Ent As stEntity
    Dim i As Integer
    Dim aLBound As Integer
    Dim aUBound As Integer
    Dim DynamicField As stDynamicFieldsStruct
    
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & Method
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'Serializer.Init Connector.InputStream
    serializer.InitWithComposer Connector.InputStream, Composer
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<InsertRegistry xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    'Domain and user name
    serializer.WriteXml "<strDomainAndUsername>" & DomainAndUsername & "</strDomainAndUsername>"
    ' Password
    serializer.WriteXml "<strPassword>" & Password & "</strPassword>"
    ' Registry
    serializer.WriteXml "<Registry>"
    ' Book
    serializer.WriteXml "<Book>"
        serializer.WriteXml "<BookAbreviation>" & Book.Abreviation & "</BookAbreviation>"
    serializer.WriteXml "</Book>"
    ' Year
    serializer.WriteXml "<Year>" & RegYear & "</Year>"
    ' Number
    If Trim(RegNumber) <> "" Then
        serializer.WriteXml "<Number>" & Trim(RegNumber) & "</Number>"
    End If
    ' Register Date
    serializer.WriteXml "<RegistryDate>" & ConvertDateToString(RegDate) & "</RegistryDate>"
    ' Subject
    serializer.WriteXml "<Subject>"
        ConvertStringToWebService serializer, Subject
    serializer.WriteXml "</Subject>"
    ' Observs
    serializer.WriteXml "<Observations>"
        ConvertStringToWebService serializer, Observations
    serializer.WriteXml "</Observations>"
    ' Referência
    serializer.WriteXml "<Reference>"
        ConvertStringToWebService serializer, Reference
    serializer.WriteXml "</Reference>"
    ' Document Type
    serializer.WriteXml "<DocumentType>"
        serializer.WriteXml "<DocumentTypeID>0</DocumentTypeID>"
        serializer.WriteXml "<DocumentTypeAbreviation>" & DocumentType.DocumentTypeAbreviation & "</DocumentTypeAbreviation>"
        serializer.WriteXml "<DocumentTypeDescription></DocumentTypeDescription>"
    serializer.WriteXml "</DocumentType>"
    ' Document Date
    serializer.WriteXml "<DocumentDate>" & ConvertDateToString(DocDate) & "</DocumentDate>"
    'Classification
    If Classification.Level1Abreviation <> "" Then
        serializer.WriteXml "<Classification>"
            serializer.WriteXml "<ClassificationID>0</ClassificationID>"
            serializer.WriteXml "<Level1Abreviation>" & Classification.Level1Abreviation & "</Level1Abreviation>"
            serializer.WriteXml "<Level1Description></Level1Description>"
            serializer.WriteXml "<Level2Abreviation>" & Classification.Level2Abreviation & "</Level2Abreviation>"
            serializer.WriteXml "<Level2Description></Level2Description>"
            serializer.WriteXml "<Level3Abreviation>" & Classification.Level3Abreviation & "</Level3Abreviation>"
            serializer.WriteXml "<Level3Description></Level3Description>"
            serializer.WriteXml "<Level4Abreviation>" & Classification.Level4Abreviation & "</Level4Abreviation>"
            serializer.WriteXml "<Level4Description></Level4Description>"
            serializer.WriteXml "<Level5Abreviation>" & Classification.Level5Abreviation & "</Level5Abreviation>"
            serializer.WriteXml "<Level5Description></Level5Description>"
        serializer.WriteXml "</Classification>"
    End If
    ' Entity
    serializer.WriteXml "<Entity>"
        serializer.WriteXml "<EntityID>" & MainEntity.ConnectID & "</EntityID>"
        serializer.WriteXml "<EntityName>"
            ConvertStringToWebService serializer, MainEntity.Name
        serializer.WriteXml "</EntityName>"
        serializer.WriteXml "<EntityExchangeID></EntityExchangeID>"
    serializer.WriteXml "</Entity>"
    ' More Entities
    If OtherEntities(0).ConnectID > 0 Then
        aLBound = LBound(OtherEntities)
        aUBound = UBound(OtherEntities)
        serializer.WriteXml "<MoreEntities>"
        For i = aLBound To aUBound
            Ent = OtherEntities(i)
            If Ent.ConnectID > 0 Then
                serializer.WriteXml "<stEntity>"
                    serializer.WriteXml "<EntityID>" & Ent.ConnectID & "</EntityID>"
                    serializer.WriteXml "<EntityName>"
                        ConvertStringToWebService serializer, Ent.Name
                    serializer.WriteXml "</EntityName>"
                    serializer.WriteXml "<EntityExchangeID></EntityExchangeID>"
                    serializer.WriteXml "<EntityType>" & ConvertEntToString(Ent.Type) & "</EntityType>"
               serializer.WriteXml "</stEntity>"
            End If
        Next
        serializer.WriteXml "</MoreEntities>"
    End If
    ' Dynamic Fields
    If DynamicFields(0).DynamicFieldName <> "" Then
        aLBound = LBound(DynamicFields)
        aUBound = UBound(DynamicFields)
        serializer.WriteXml "<DynamicFields>"
        For i = aLBound To aUBound
            DynamicField = DynamicFields(i)
            If DynamicField.DynamicFieldName <> "" Then
                serializer.WriteXml "<stDynamicField>"
                    serializer.WriteXml "<DynamicFieldID>" & DynamicField.DynamicFieldID & "</DynamicFieldID>"
                    serializer.WriteXml "<DynamicFieldType>" & DynamicField.DynamicFieldType & "</DynamicFieldType>"
                    serializer.WriteXml "<DynamicFieldName>"
                        ConvertStringToWebService serializer, DynamicField.DynamicFieldName
                    serializer.WriteXml "</DynamicFieldName>"
                    serializer.WriteXml "<DynamicFieldValue>"
                        ConvertStringToWebService serializer, DynamicField.DynamicFieldValue
                    serializer.WriteXml "</DynamicFieldValue>"
               serializer.WriteXml "</stDynamicField>"
            End If
        Next
        serializer.WriteXml "</DynamicFields>"
    End If

    ' ********************************************************
    ' ****************** FILES START *************************
    ' ********************************************************
    Dim FileAttach As New MSSOAPLib30.FileAttachment30
    FileAttach.FileName = PostFilePathName
    FileAttach.Property("DimeID") = RemoveInvalidChars(RealFileName)
    serializer.AddAttachment FileAttach
    ' ******************************************************
    ' ****************** FILES END *************************
    ' ******************************************************
    
    ' Process
    serializer.WriteXml "<Process>"
        ConvertStringToWebService serializer, Process
    serializer.WriteXml "</Process>"
    ' User
    serializer.WriteXml "<User>"
        serializer.WriteXml "<UserLogin>" & DomainAndUsername & "</UserLogin>"
    serializer.WriteXml "</User>"
    
    serializer.WriteXml "</Registry>"
    serializer.WriteXml "</InsertRegistry>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    ' "Registo Não inserido..."
    If Not Reader.Fault Is Nothing Then
        ' MsgBox Reader.FaultString.Text
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
        ExecuteWebMethodEx = 0
    Else
        ' Registo Não inserido...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao inserir no OfficeWorks"
            ExecuteWebMethodEx = 0
        Else
            ' "Registo inserido com sucesso..."
            ExecuteWebMethodEx = Reader.RpcResult.Text
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Function


' ONLY USES: Book Abreviation, DocumentTypeAbreviation and entity name
' OtherEntities(0)="" if no entities wanted
' RETURNS  : 0 -> If error
'            regid otherwise
Public Function ExecuteWebMethodEx1(ByVal EndPointURL As String, _
                                    ByVal DomainAndUsername As String, _
                                    ByVal Password As String, _
                                    ByVal Method As String, _
                                    ByVal RegYear As String, _
                                    ByVal RegDate As String, _
                                    ByVal DocDate As String, _
                                    ByRef Book As stBook, _
                                    ByRef DocumentType As stDocumentType, _
                                    ByRef MainEntity As stEntity, _
                                    ByRef OtherEntities() As stEntity, _
                                    ByRef DynamicFields() As stDynamicFieldsStruct, _
                                    ByRef Classification As stClassification, _
                                    ByVal RealFileName As String, _
                                    ByVal PostFilePathName As String, _
                                    ByVal RegNumber As String, _
                                    Optional ByVal Subject As String = "", _
                                    Optional ByVal Reference As String = "", _
                                    Optional ByVal Process As String = "", _
                                    Optional ByVal Observations As String = "") As String

    On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim Composer As New MSSOAPLib30.DimeComposer30
    Dim Ent As stEntity
    Dim i As Integer
    Dim aLBound As Integer
    Dim aUBound As Integer
    Dim DynamicField As stDynamicFieldsStruct
    
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & Method
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'Serializer.Init Connector.InputStream
    serializer.InitWithComposer Connector.InputStream, Composer
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<InsertRegistry xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    'Domain and user name
    serializer.WriteXml "<strDomainAndUsername>" & DomainAndUsername & "</strDomainAndUsername>"
    ' Password
    serializer.WriteXml "<strPassword>" & Password & "</strPassword>"
    ' Registry
    serializer.WriteXml "<Registry>"
    ' Book
    serializer.WriteXml "<Book>"
        serializer.WriteXml "<BookAbreviation>" & Book.Abreviation & "</BookAbreviation>"
    serializer.WriteXml "</Book>"
    ' Year
    serializer.WriteXml "<Year>" & RegYear & "</Year>"
    ' Number
    If Trim(RegNumber) <> "" Then
        serializer.WriteXml "<Number>" & Trim(RegNumber) & "</Number>"
    End If
    ' Register Date
    serializer.WriteXml "<RegistryDate>" & ConvertDateToString(CDate(RegDate)) & "</RegistryDate>"
    ' Subject
    serializer.WriteXml "<Subject>"
        ConvertStringToWebService serializer, Subject
    serializer.WriteXml "</Subject>"
    ' Observs
    serializer.WriteXml "<Observations>"
        ConvertStringToWebService serializer, Observations
    serializer.WriteXml "</Observations>"
    ' Referência
    serializer.WriteXml "<Reference>"
        ConvertStringToWebService serializer, Reference
    serializer.WriteXml "</Reference>"
    ' Document Type
    serializer.WriteXml "<DocumentType>"
        serializer.WriteXml "<DocumentTypeID>0</DocumentTypeID>"
        serializer.WriteXml "<DocumentTypeAbreviation>" & DocumentType.DocumentTypeAbreviation & "</DocumentTypeAbreviation>"
        serializer.WriteXml "<DocumentTypeDescription></DocumentTypeDescription>"
    serializer.WriteXml "</DocumentType>"
    ' Document Date
    If DocDate <> "" Then
        serializer.WriteXml "<DocumentDate>" & ConvertDateToString(CDate(DocDate)) & "</DocumentDate>"
    End If
    'Classification
    If Classification.Level1Abreviation <> "" Then
        serializer.WriteXml "<Classification>"
            serializer.WriteXml "<ClassificationID>0</ClassificationID>"
            serializer.WriteXml "<Level1Abreviation>" & Classification.Level1Abreviation & "</Level1Abreviation>"
            serializer.WriteXml "<Level1Description></Level1Description>"
            serializer.WriteXml "<Level2Abreviation>" & Classification.Level2Abreviation & "</Level2Abreviation>"
            serializer.WriteXml "<Level2Description></Level2Description>"
            serializer.WriteXml "<Level3Abreviation>" & Classification.Level3Abreviation & "</Level3Abreviation>"
            serializer.WriteXml "<Level3Description></Level3Description>"
            serializer.WriteXml "<Level4Abreviation>" & Classification.Level4Abreviation & "</Level4Abreviation>"
            serializer.WriteXml "<Level4Description></Level4Description>"
            serializer.WriteXml "<Level5Abreviation>" & Classification.Level5Abreviation & "</Level5Abreviation>"
            serializer.WriteXml "<Level5Description></Level5Description>"
        serializer.WriteXml "</Classification>"
    End If
    ' Entity
    serializer.WriteXml "<Entity>"
        serializer.WriteXml "<EntityID>" & MainEntity.ConnectID & "</EntityID>"
        serializer.WriteXml "<EntityName>"
            ConvertStringToWebService serializer, MainEntity.Name
        serializer.WriteXml "</EntityName>"
        serializer.WriteXml "<EntityExchangeID></EntityExchangeID>"
    serializer.WriteXml "</Entity>"
    ' More Entities
    If OtherEntities(0).ConnectID > 0 Then
        aLBound = LBound(OtherEntities)
        aUBound = UBound(OtherEntities)
        serializer.WriteXml "<MoreEntities>"
        For i = aLBound To aUBound
            Ent = OtherEntities(i)
            If Ent.ConnectID > 0 Then
                serializer.WriteXml "<stEntity>"
                    serializer.WriteXml "<EntityID>" & Ent.ConnectID & "</EntityID>"
                    serializer.WriteXml "<EntityName>"
                        ConvertStringToWebService serializer, Ent.Name
                    serializer.WriteXml "</EntityName>"
                    serializer.WriteXml "<EntityExchangeID></EntityExchangeID>"
                    serializer.WriteXml "<EntityType>" & ConvertEntToString(Ent.Type) & "</EntityType>"
               serializer.WriteXml "</stEntity>"
            End If
        Next
        serializer.WriteXml "</MoreEntities>"
    End If
    ' Dynamic Fields
    If DynamicFields(0).DynamicFieldName <> "" Then
        aLBound = LBound(DynamicFields)
        aUBound = UBound(DynamicFields)
        serializer.WriteXml "<DynamicFields>"
        For i = aLBound To aUBound
            DynamicField = DynamicFields(i)
            If DynamicField.DynamicFieldName <> "" Then
                serializer.WriteXml "<stDynamicField>"
                    serializer.WriteXml "<DynamicFieldID>" & DynamicField.DynamicFieldID & "</DynamicFieldID>"
                    serializer.WriteXml "<DynamicFieldType>" & DynamicField.DynamicFieldType & "</DynamicFieldType>"
                    serializer.WriteXml "<DynamicFieldName>"
                        ConvertStringToWebService serializer, DynamicField.DynamicFieldName
                    serializer.WriteXml "</DynamicFieldName>"
                    serializer.WriteXml "<DynamicFieldValue>"
                        ConvertStringToWebService serializer, DynamicField.DynamicFieldValue
                    serializer.WriteXml "</DynamicFieldValue>"
               serializer.WriteXml "</stDynamicField>"
            End If
        Next
        serializer.WriteXml "</DynamicFields>"
    End If

    ' ********************************************************
    ' ****************** FILES START *************************
    ' ********************************************************
    Dim FileAttach As New MSSOAPLib30.FileAttachment30
    FileAttach.FileName = PostFilePathName
    FileAttach.Property("DimeID") = RemoveInvalidChars(RealFileName)
    serializer.AddAttachment FileAttach
    ' ******************************************************
    ' ****************** FILES END *************************
    ' ******************************************************
    
    ' Process
    serializer.WriteXml "<Process>"
        ConvertStringToWebService serializer, Process
    serializer.WriteXml "</Process>"
    ' User
    serializer.WriteXml "<User>"
        serializer.WriteXml "<UserLogin>" & DomainAndUsername & "</UserLogin>"
    serializer.WriteXml "</User>"
    
    serializer.WriteXml "</Registry>"
    serializer.WriteXml "</InsertRegistry>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    ' "Registo Não inserido..."
    If Not Reader.Fault Is Nothing Then
        ' MsgBox Reader.FaultString.Text
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
        ExecuteWebMethodEx1 = 0
    Else
        ' Registo Não inserido...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao inserir no OfficeWorks"
            ExecuteWebMethodEx1 = 0
        Else
            ' "Registo inserido com sucesso..."
            ExecuteWebMethodEx1 = Reader.RpcResult.Text
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Function


' FUNCTION: Convert XML to a book structure array
' RECEIVES: Reader -> SoapReader30 object
' RETURNS : aBook  -> book structure array
Private Sub ConvertXML2Book(ByVal Reader As MSSOAPLib30.SoapReader30, _
                            ByRef aBook() As stBook)
On Error GoTo ErrSub
    Dim pNode As MSXML2.IXMLDOMNode
    Dim xmlDoc As MSXML2.DOMDocument
    Dim i As Long
    Set xmlDoc = New MSXML2.DOMDocument
    
    xmlDoc.async = False
    xmlDoc.LoadXml Reader.RpcResult.xml
    
    If (xmlDoc.parseError.errorCode <> 0) Then
        Dim myErr
        Set myErr = xmlDoc.parseError
        Err.Raise vbError + 1, "OWApi", myErr.reason
    Else
        ' If no book returned
        If xmlDoc.documentElement.childNodes.length = 0 Then
            Err.Raise vbError + 1, "OWApi", "Não tem acesso de registo a nenhum livro."
        Else ' Returned one or more books
            ' Get each book struct
            ReDim aBook(xmlDoc.documentElement.childNodes.length)
            For i = 0 To (xmlDoc.documentElement.childNodes.length - 1)
                Set pNode = xmlDoc.documentElement.childNodes.Item(i)
                aBook(i).Abreviation = pNode.selectSingleNode("BookAbreviation").nodeTypedValue ' .childNodes.Item(0).nodeTypedValue
                aBook(i).BookID = pNode.selectSingleNode("BookID").nodeTypedValue
                aBook(i).Name = pNode.selectSingleNode("BookDescription").nodeTypedValue
            Next

        End If
        
    End If

ExitSub:
    Exit Sub
ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
End Sub
' FUNCTION: Convert XML to a book structure array
' RECEIVES: Reader -> SoapReader30 object
' RETURNS : aBook  -> book structure array
Private Sub ConvertXML2Group(ByVal Reader As MSSOAPLib30.SoapReader30, _
                            ByRef aGroup() As stGroup)
On Error GoTo ErrSub
    Dim pNode As MSXML2.IXMLDOMNode
    Dim xmlDoc As MSXML2.DOMDocument
    Dim i As Long
    Set xmlDoc = New MSXML2.DOMDocument
    
    xmlDoc.async = False
    xmlDoc.LoadXml Reader.RpcResult.xml
    
    If (xmlDoc.parseError.errorCode <> 0) Then
        Dim myErr
        Set myErr = xmlDoc.parseError
        Err.Raise vbError + 1, "OWApi", myErr.reason
    Else
        ' if no group returned
        If xmlDoc.documentElement.childNodes.length = 0 Then
            Exit Sub
        Else ' Returned one or more books
            ' Get each book struct
            ReDim aGroup(xmlDoc.documentElement.childNodes.length)
            For i = 0 To (xmlDoc.documentElement.childNodes.length - 1)
                Set pNode = xmlDoc.documentElement.childNodes.Item(i)
                aGroup(i).GroupID = pNode.selectSingleNode("GroupID").nodeTypedValue
                aGroup(i).Description = pNode.selectSingleNode("Description").nodeTypedValue
            Next
        End If
    End If

ExitSub:
    Exit Sub
ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
End Sub
' ONLY USES: Book Abreviation, DocumentTypeAbreviation and entity name
' OtherEntities(0)="" if no entities wanted
' RETURNS  : 0 -> If error
'            regid otherwise
Public Sub GetBooks(ByVal EndPointURL As String, _
                         ByVal DomainAndUsername As String, _
                         ByVal Password As String, _
                         ByVal Role As ROLE_TYPE, _
                         ByRef aBooks() As stBook)
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim i As Integer
    Dim lRole As Long
    
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "GetBook"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<GetBook  xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    lRole = Role
    serializer.WriteXml "<login>" & DomainAndUsername & "</login>"
    serializer.WriteXml "<role>" & lRole & "</role>"
    serializer.WriteXml "</GetBook>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Livros não obtidos...
    If Not Reader.Fault Is Nothing Then
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
    Else
        'Livros não obtidos...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao obter livros do OfficeWorks"
        Else
            'Livros com sucesso..."
            ConvertXML2Book Reader, aBooks
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Sub

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Sub
' ONLY USES: Book Abreviation, DocumentTypeAbreviation and entity name
' OtherEntities(0)="" if no entities wanted
' RETURNS  : 0 -> If error
'            regid otherwise
Public Function GetEntitiesGroups(ByVal EndPointURL As String, ByRef aGroup() As stGroup)
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim i As Integer
        
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "GetEntitiesGroups"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<GetEntitiesGroups xmlns=""http://tempuri.org/"">"
    serializer.WriteXml "</GetEntitiesGroups>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Entidades não obtidas...
    If Not Reader.Fault Is Nothing Then
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
    Else
        'Entidades não obtidas...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao obter Entidades do OfficeWorks"
        Else
            'Entidades obtidas com sucesso..."
            ConvertXML2Group Reader, aGroup
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Function


' ONLY USES: Book Abreviation, DocumentTypeAbreviation and entity name
' OtherEntities(0)="" if no entities wanted
' RETURNS  : 0 -> If error
'            regid otherwise
Public Function GetGroupsEntities(ByVal EndPointURL As String, _
                                  ByVal Identifier As Long, _
                                  ByVal Description As String, _
                                  ByRef aGroup() As stGroup)
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim i As Integer
        
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "GetGroupsEntities"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<GetGroupsEntities xmlns=""http://tempuri.org/"">"
    serializer.WriteXml "<Identifier>" & Identifier & "</Identifier>"
    serializer.WriteXml "<Description>" & Description & "</Description>"
    serializer.WriteXml "</GetGroupsEntities>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Erro ao obter os elementos do grupo...
    If Not Reader.Fault Is Nothing Then
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
    Else
        'Erro ao obter os elementos do grupo...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao obter os elementos do Grupo do OfficeWorks"
        Else
            'Elementos do Grupo obtidos com sucesso...
            ConvertXML2Group Reader, aGroup
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Function




' FUNCTION: Upload a file to OfficeWorks Server
' RECEIVES:
' RETURNS :
Public Function UploadFile(ByVal EndPointURL As String, _
                      ByVal DomainAndUsername As String, _
                      ByVal Password As String, _
                      ByVal PostFilePathName As String) As String
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim Composer As New MSSOAPLib30.DimeComposer30
                    
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "UploadFile"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'Serializer.Init Connector.InputStream
    serializer.InitWithComposer Connector.InputStream, Composer
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<UploadFile xmlns=""http://tempuri.org/"">"
    
    ' ********************************************************
    ' ****************** FILES START *************************
    ' ********************************************************
    Dim FileAttach As New MSSOAPLib30.FileAttachment30
    
    FileAttach.FileName = PostFilePathName
    'FileAttach.Property("DimeTNF") = "media-type"
    'FileAttach.Property("DimeType") = "application/pdf"
    FileAttach.Property("DimeID") = RemoveInvalidChars(PostFilePathName)
    serializer.AddAttachment FileAttach
    
    ' ******************************************************
    ' ****************** FILES END *************************
    ' ******************************************************
    
    serializer.WriteXml "</UploadFile>"
        
    ' Close envelope
    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Erro ao transferir o ficheiro
    If Not Reader.Fault Is Nothing Then
        ' MsgBox Reader.FaultString.Text
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
        UploadFile = ""
    Else
        'Erro ao transferir o ficheiro
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao transferir o ficheiro"
            UploadFile = ""
        Else
            'Ficheiro tranferido com sucesso..."
            UploadFile = Reader.RpcResult.Text
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Function


' RETURNS  : 0 -> If error
'            regid otherwise
Public Sub GetLists(ByVal EndPointURL As String, _
                         ByVal DomainAndUsername As String, _
                         ByVal Password As String, _
                         ByVal Role As ROLE_TYPE, _
                         ByRef aLists() As stList)
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim i As Integer
    Dim lRole As Long
    
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "GetList"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<GetList  xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    lRole = Role
    serializer.WriteXml "<login>" & DomainAndUsername & "</login>"
    serializer.WriteXml "<role>" & lRole & "</role>"
    serializer.WriteXml "</GetList>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Erro ao obter listas...
    If Not Reader.Fault Is Nothing Then
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
    Else
        'Erro ao obter listas...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao pesquisar no OfficeWorks"
        Else
            'Listas obtidas com sucesso..."
            ConvertXML2List Reader, aLists
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Sub

ErrSub:
    Screen.MousePointer = vbDefault
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Sub


' FUNCTION: Convert XML to a list structure array
' RECEIVES: Reader -> SoapReader30 object
' RETURNS : aList  -> list structure array
Private Sub ConvertXML2List(ByVal Reader As MSSOAPLib30.SoapReader30, _
                            ByRef aList() As stList)
On Error GoTo ErrSub
    Dim pNode As MSXML2.IXMLDOMNode
    Dim xmlDoc As MSXML2.DOMDocument
    Dim i As Long
    Set xmlDoc = New MSXML2.DOMDocument
    
    xmlDoc.async = False
    xmlDoc.LoadXml Reader.RpcResult.xml
    
    If (xmlDoc.parseError.errorCode <> 0) Then
        Dim myErr
        Set myErr = xmlDoc.parseError
        Err.Raise vbError + 1, "OWApi", myErr.reason
    Else
        ' If no list returned
        If xmlDoc.documentElement.childNodes.length = 0 Then
            Err.Raise vbError + 1, "OWApi", "Não tem acesso de pesquisa a nenhuma entidade!"
        Else ' Returned one or more list
            ' Get each list struct
            ReDim aList(xmlDoc.documentElement.childNodes.length)
            For i = 0 To (xmlDoc.documentElement.childNodes.length - 1)
                Set pNode = xmlDoc.documentElement.childNodes.Item(i)
                aList(i).ListID = pNode.selectSingleNode("ListId").nodeTypedValue
                aList(i).Description = pNode.selectSingleNode("ListDescription").nodeTypedValue
            Next
        End If
    End If

ExitSub:
    Exit Sub
ErrSub:
    Screen.MousePointer = vbDefault
    Err.Raise Err.Number, "OWApi", Err.Description
End Sub


' RETURNS  : 0 -> If error
'            regid otherwise
Public Sub GetContact(ByVal EndPointURL As String, _
                         ByRef FieldsColl() As stFieldsStruct, _
                         ByVal Full As Boolean, _
                         ByVal DomainAndUsername As String, _
                         ByVal Password As String, _
                         ByVal Role As String, _
                         ByVal PageNumber As Long, _
                         ByVal PageSize As Long, _
                         ByRef NumReg As Long, _
                         ByRef aContacts() As stContact)
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    Dim sFieldsStruct As String
    Dim i As Integer
    Dim lFull As Long

    
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "GetContact"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define Web Method Parameters
    lFull = IIf(Full, 1, 0)
    
    sFieldsStruct = ""
    For i = 0 To (UBound(FieldsColl))
        sFieldsStruct = sFieldsStruct & "<stFieldsStruct>"
        sFieldsStruct = sFieldsStruct & "<FieldID>" & FieldsColl(i).FieldID & "</FieldID>"
        sFieldsStruct = sFieldsStruct & "<FieldType>" & FieldsColl(i).FieldType & "</FieldType>"
        sFieldsStruct = sFieldsStruct & "<FieldValue>" & FieldsColl(i).FieldValue & "</FieldValue>"
        sFieldsStruct = sFieldsStruct & "</stFieldsStruct>"
    Next
    
    ' Define method to execute
    serializer.WriteXml "<GetContact  xmlns=""http://tempuri.org/"">"
    serializer.WriteXml "<FieldsColl>" & sFieldsStruct & "</FieldsColl>"
    serializer.WriteXml "<Full>" & lFull & "</Full>"
    serializer.WriteXml "<Login>" & DomainAndUsername & "</Login>"
    serializer.WriteXml "<Role>" & Role & "</Role>"
    serializer.WriteXml "<PageNumber>" & PageNumber & "</PageNumber>"
    serializer.WriteXml "<PageSize>" & PageSize & "</PageSize>"
    serializer.WriteXml "<NumReg>" & NumReg & "</NumReg>"
    serializer.WriteXml "</GetContact>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Erro ao obter contactos...
    If Not Reader.Fault Is Nothing Then
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
    Else
        'Erro ao obter contactos...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao pesquisar no OfficeWorks"
        Else
            'Contactos obtidos com sucesso..."
            ''Get num reg from return param
            NumReg = CLng(0 & GetReturnValue(Reader, "NumReg"))
            If NumReg > 0 Then ConvertXML2Contact Reader, aContacts
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Sub

ErrSub:
    Screen.MousePointer = vbDefault
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Sub


' FUNCTION: Convert XML to a contact structure array
' RECEIVES: Reader -> SoapReader30 object
' RETURNS : aContact  -> contact structure array
Private Sub ConvertXML2Contact(ByVal Reader As MSSOAPLib30.SoapReader30, _
                            ByRef aContact() As stContact)
On Error GoTo ErrSub
    Dim pNode As MSXML2.IXMLDOMNode
    Dim xmlDoc As MSXML2.DOMDocument
    Dim i As Long
    Set xmlDoc = New MSXML2.DOMDocument
    
    xmlDoc.async = False
    xmlDoc.LoadXml Reader.RpcResult.xml

    If (xmlDoc.parseError.errorCode <> 0) Then
        Dim myErr
        Set myErr = xmlDoc.parseError
        Err.Raise vbError + 1, "OWApi", myErr.reason
    Else
        ' If no contact returned
        If xmlDoc.documentElement.childNodes.length = 0 Then
            Err.Raise vbError + 1, "OWApi", "Não tem acesso de pesquisa a nenhum contacto."
        Else ' Returned one or more contact
            ' Get each contact struct
            ReDim aContact(xmlDoc.documentElement.childNodes.length)
            For i = 0 To (xmlDoc.documentElement.childNodes.length - 1)
                Set pNode = xmlDoc.documentElement.childNodes.Item(i)
                aContact(i).ContactID = pNode.selectSingleNode("ContactID").nodeTypedValue
                aContact(i).FieldID = pNode.selectSingleNode("FieldID").nodeTypedValue
                aContact(i).FieldValue = pNode.selectSingleNode("FieldValue").nodeTypedValue
            Next
        End If
        
    End If

ExitSub:
    Exit Sub
ErrSub:
    Screen.MousePointer = vbDefault
    Err.Raise Err.Number, "OWApi", Err.Description
End Sub


' RETURNS  : 0 -> If error
'            regid otherwise
Public Sub GetRegistryListValues(ByVal EndPointURL As String, _
                         ByVal ListName As String, _
                         ByRef aListValues() As stItem)
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "GetRegistryListValues"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<GetRegistryListValues xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    serializer.WriteXml "<ListName>" & ListName & "</ListName>"
    
    serializer.WriteXml "</GetRegistryListValues>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Erro ao obter valores da lista...
    If Not Reader.Fault Is Nothing Then
        Err.Raise vbError + 1, "OWApi", Reader.FaultString.Text
    Else
        'Erro ao obter valores da lista...
        If Reader.RpcResult Is Nothing Then
            Err.Raise vbError + 1, "OWApi", "Erro ao obter valores da lista no OfficeWorks"
        Else
            'Valores da lista obtidos com sucesso...
            ConvertXML2RegistryListValues Reader, aListValues
        End If
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Sub

ErrSub:
    Screen.MousePointer = vbDefault
    Err.Raise Err.Number, "OWApi", Err.Description
    Resume ExitSub
End Sub


' FUNCTION: Convert XML to a list structure array
' RECEIVES: Reader -> SoapReader30 object
' RETURNS : aList  -> list structure array
Private Sub ConvertXML2RegistryListValues(ByVal Reader As MSSOAPLib30.SoapReader30, _
                            ByRef aListValues() As stItem)
On Error GoTo ErrSub
    Dim pNode As MSXML2.IXMLDOMNode
    Dim xmlDoc As MSXML2.DOMDocument
    Dim i As Long
    Set xmlDoc = New MSXML2.DOMDocument
    
    xmlDoc.async = False
    xmlDoc.LoadXml Reader.RpcResult.xml
    
    If (xmlDoc.parseError.errorCode <> 0) Then
        Dim myErr
        Set myErr = xmlDoc.parseError
        Err.Raise vbError + 1, "OWApi", myErr.reason
    Else
        ' If no list returned
        If xmlDoc.documentElement.childNodes.length = 0 Then
            Err.Raise vbError + 1, "OWApi", "Não existem valores para a lista!"
        Else ' Returned one or more list
            ' Get each list struct
            ReDim aListValues(xmlDoc.documentElement.childNodes.length)
            For i = 0 To (xmlDoc.documentElement.childNodes.length - 1)
                Set pNode = xmlDoc.documentElement.childNodes.Item(i)
                aListValues(i).Identifier = pNode.selectSingleNode("Identifier").nodeTypedValue
                aListValues(i).Value = pNode.selectSingleNode("Value").nodeTypedValue
                aListValues(i).Other = pNode.selectSingleNode("Other").nodeTypedValue
            Next
        End If
    End If

ExitSub:
    Exit Sub
ErrSub:
    Screen.MousePointer = vbDefault
    Err.Raise Err.Number, "OWApi", Err.Description
End Sub


''Get returned value for param
Public Function GetReturnValue(ByVal Reader As MSSOAPLib30.SoapReader30, sParamName As String) As String
    Dim xmlDoc As MSXML2.DOMDocument
    Dim entry
    
    GetReturnValue = ""
    Set xmlDoc = New MSXML2.DOMDocument
    For Each entry In Reader.BodyEntries
        xmlDoc.LoadXml entry.xml
    Next
    If xmlDoc.documentElement.lastChild.baseName = sParamName Then
        GetReturnValue = xmlDoc.documentElement.lastChild.Text
    End If
End Function


' RETURNS  : 0 -> If ok
'            <> 0 -> if error
Public Function SetRegistryHierarchicalAccess(ByVal EndPointURL As String, _
                         ByVal RegId As String, _
                         ByVal UserLogin As String, _
                         ByVal AccessType As String) As String
On Error GoTo ErrSub

    Dim Connector As MSSOAPLib30.HttpConnector30
    Dim serializer As MSSOAPLib30.SoapSerializer30
    Dim Reader As MSSOAPLib30.SoapReader30
    
    'Dim soapclient As SoapClient30
    Set Connector = New MSSOAPLib30.HttpConnector30
    Connector.Property("EndPointURL") = EndPointURL
    Connector.Property("SoapAction") = BASE_SOAP_ACTION_URI & "SetHierarchicalAccess"
    Connector.BeginMessage
    
    Set serializer = New MSSOAPLib30.SoapSerializer30
    
    'serializer.InitWithComposer Connector.InputStream
    serializer.Init Connector.InputStream
    
    serializer.StartEnvelope "soap", "STANDARD", "utf-8"
    serializer.StartBody "STANDARD"
    
    ' Define method to execute
    serializer.WriteXml "<SetHierarchicalAccess xmlns=""http://tempuri.org/"">"
    
    ' Define Web Method Parameters
    serializer.WriteXml "<RegistryIdentifier>" & RegId & "</RegistryIdentifier>"
    serializer.WriteXml "<Login>" & UserLogin & "</Login>"
    serializer.WriteXml "<objectType>" & AccessType & "</objectType>"
    
    serializer.WriteXml "</SetHierarchicalAccess>"
    
    ' Close envelope

    serializer.EndBody
    serializer.EndEnvelope
    
    serializer.Finished
    Connector.EndMessage
    
    Set Reader = New MSSOAPLib30.SoapReader30
    Reader.Load Connector.OutputStream ' connect to SOAP response
    
    'Erro ao atribuir acessos...
    If Not Reader.Fault Is Nothing Then
        SetRegistryHierarchicalAccess = "OWApi - Erro nº: " & vbError + 1 & " Desc: " & Reader.FaultString.Text
    Else
        'Acessos atribuidos com sucesso...
        SetRegistryHierarchicalAccess = ""
    End If

ExitSub:
    Set Reader = Nothing
    Set Connector = Nothing
    Set serializer = Nothing
    Exit Function

ErrSub:
    Screen.MousePointer = vbDefault
    SetRegistryHierarchicalAccess = "OWApi - Erro nº: " & Err.Number & " Desc: " & Err.Description
    Resume ExitSub
End Function


