'==============================================================================
' regevent.vbs
'       Purpose
'               Utility to manipulate Exchange OLEDB Event bindings database
'
' Copyright (c) 1998-1999 Microsoft Corporation
'===============================================================================
Option Explicit

'=========================================================================
'Event binding property names and keys to access them.
'  Any future sink property should be defined before BeginBindingProps
'==========================================================================
Dim BeginSinkProps,EndSinkProps,BeginBindingProps,EndBindingProps
Dim aPropNames                  'Array of property names
Dim aPropShortNames
Dim aPropValues(11)             'Array of property values. We use this to pass args to the subroutine
Dim cPropNames                  'Array size

cPropNames = 11      'Array size

Dim ndxContentClass
Dim ndxEventMethod
Dim ndxSinkClass
Dim ndxPriority
Dim ndxScope
Dim ndxMatchScope
Dim ndxCriteria
Dim ndxTimerInterval
Dim ndxTimerStartTime
Dim ndxTimerExpireTime
Dim ndxScriptUrl

aPropShortNames = Array( _
	"ContentClass", _
	"EventMethod", _
	"SinkClass", _ 
	"Priority", _ 
	"Scope", _ 
	"MatchScope", _ 
	"CriteriaFilter", _ 
	"Interval", _ 
	"StartTime", _ 
	"ExpiryTime", _ 
	"ScriptUrl")

aPropNames = Array( _
    "DAV:contentclass", _
    "http://schemas.microsoft.com/exchange/events/EventMethod", _
    "http://schemas.microsoft.com/exchange/events/SinkClass", _
    "http://schemas.microsoft.com/exchange/events/Priority", _
    "http://schemas.microsoft.com/exchange/events/Scope", _
    "http://schemas.microsoft.com/exchange/events/MatchScope", _
    "http://schemas.microsoft.com/exchange/events/Criteria", _
    "http://schemas.microsoft.com/exchange/events/TimerInterval", _
    "http://schemas.microsoft.com/exchange/events/TimerStartTime", _
    "http://schemas.microsoft.com/exchange/events/TimerExpiryTime", _
    "http://schemas.microsoft.com/exchange/events/ScriptUrl")

BeginBindingProps = 0	'1st index of Binding props
ndxContentClass = 0
ndxEventMethod = 1
ndxSinkClass = 2
ndxPriority = 3
ndxScope = 4
ndxMatchScope = 5
ndxCriteria = 6
ndxTimerInterval = 7
ndxTimerStartTime = 8
ndxTimerExpireTime = 9
ndxScriptUrl = 10
EndBindingProps = 10

BeginSinkProps = 11	'Sink prop begins next
EndSinkProps = 11


' Get the arguments and the argument count
Dim obArgs
Dim cArgs

Set obArgs = WScript.Arguments
cArgs = obArgs.Count

' Call the sub to handle event administration stuff
EventAdmin

'=============================================================================='
' This is the main body of execution. Looks at input arguments and calls the
' appropriate event handling routines.
'=============================================================================='
Sub EventAdmin()
    If cArgs < 1 Then
        Usage
        Exit Sub
    End If
    Select Case LCase(obArgs.Item(0))
        Case "add"
            AddEvent
        Case "delete"
            DeleteEvent
        Case "enum"
            EnumEvent
        Case Else
            Usage
    End Select
End Sub

'=============================================================================='
' This routine registers event binding..
'=============================================================================='
Sub AddEvent()
    ' Check minimum set of args
    If cArgs < 3 Then
        Usage
        Exit Sub
    End If

    Select Case LCase(obArgs.Item(1))
        Case "ontimer"
            RegisterTimerEvent
        Case "onmdbstartup", "onmdbshutdown"
            RegisterStartStopEvent
        Case Else
            RegisterStoreEvent
    End Select
End Sub
    
'=============================================================================='
' delete eventbindingurl
'=============================================================================='
Sub DeleteEvent()
	On Error Resume Next
	If cArgs = 2 Or cArgs = 3 Then
		Dim Query
		Dim cn
		Dim rec
		Dim rs
		Dim strParentFolder
		Dim strEventRegistrationName
    
		Set cn = CreateObject("ADODB.Connection")
		Set rs = CreateObject("ADODB.Recordset")
		Set rec = CreateObject("ADODB.Record")

		' Separate the event folder from the event registration name	
		If SeparateBindingUrl(strParentFolder, strEventRegistrationName) = false Then
			Exit Sub
		End If

		' Build the sql query depending
		Call BuildQueryString(strParentFolder, strEventRegistrationName, Query)

		' Create a connection
		cn.Provider = "exoledb.datasource"
		cn.ConnectionString = strParentFolder
		cn.Open
		If Err.Number <> 0 Then
			WScript.Echo "Error Opening Connection : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If
    
		' Create the recordset
		rs.Open Query, cn
		If Err.Number <> 0 Then
			WScript.Echo "Error Executing Query : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If
    
		' Go thru each record in the record set
		Do While (rs.BOF <> True And rs.EOF <> True)
			rec.Open rs
			If Err.Number <> 0 Then
				WScript.Echo "Error Opening Recordset : " & Err.Number & " " & Err.Description & vbCrLf
				Exit Sub
			End If
			
			WScript.Echo "Deleting " & rec.Fields.Item(aPropNames(ndxEventMethod)) & " event at " & rec.Fields.Item(aPropNames(ndxScope)).Value & vbCrLf
			rec.DeleteRecord
			If Err.Number <> 0 Then
				WScript.Echo "Error Deleting Record : " & Err.Number & " " & Err.Description & vbCrLf
				Exit Sub
			End If

			rec.Close
			If Err.Number <> 0 Then
				WScript.Echo "Error Closing Record : " & Err.Number & " " & Err.Description & vbCrLf
				Exit Sub
			End If

			rs.MoveNext
			If Err.Number <> 0 Then
				WScript.Echo "Error Moving To Next Record : " & Err.Number & " " & Err.Description & vbCrLf
				Exit Sub
			End If

		Loop
	Else
        Usage
        Exit Sub
    End If
End Sub

'=============================================================================='
' enum eventbindingurl
'=============================================================================='
Sub EnumEvent()
	On Error Resume Next
	If cArgs >= 2 Then
		Dim Query
		Dim fld
		Dim cn
		Dim rs
		Dim strParentFolder
		Dim strEventRegistrationName
		    
		Set cn = CreateObject("ADODB.Connection")
		Set rs = CreateObject("ADODB.Recordset")

		' Separate the event folder from the event registration name	
		If SeparateBindingUrl(strParentFolder, strEventRegistrationName) = false Then
			Exit Sub
		End If

		' Build the sql query depending
		Call BuildQueryString(strParentFolder, strEventRegistrationName, Query)

		' Create the connection
		cn.Provider = "exoledb.datasource"
		cn.ConnectionString = strParentFolder
		cn.Open
		If Err.Number <> 0 Then
			WScript.Echo "Error Opening Connection : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If
    
		' Create the recordset
		rs.Open Query, cn
		If Err.Number <> 0 Then
			WScript.Echo "Error Executing Query : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If
    
		' Go thru each entry in the recordset
		Do While (rs.BOF <> True And rs.EOF <> True)
			For Each fld In rs.Fields
				If fld.Value <> vbNull Then
					WScript.Echo fld.Name & ", " & fld.Value & vbCrLf
				End If
			Next
			WScript.Echo "***********************************************" & vbCrLf
			rs.MoveNext
			If Err.Number <> 0 Then
				WScript.Echo "Error Moving To Next Record : " & Err.Number & " " & Err.Description & vbCrLf
				Exit Sub
			End If
		Loop
	Else
        Usage
        Exit Sub
    End If
End Sub

'=============================================================================
' This routine add optional parameter to the propvalue array and increment counter
'=============================================================================
Sub AddOptional(keyindex, i)
    If i < cArgs - 1 Then
		If keyindex = ndxCriteria Then
			Dim quote
			quote = chr(34)
			aPropValues(keyindex) = Replace(obArgs.Item(i + 1), "$", quote)
		Else
			aPropValues(keyindex) = obArgs.Item(i + 1)
		End If
        i = i + 1
    End If
End Sub

'=============================================================================='
' This routine is used to register the ontimer system event
'
' add eventmethod sinkclass eventbindingurl start interval -e expiry [<-url ScriptUrl> | <-file ScriptFile>]
'=============================================================================='
Sub RegisterTimerEvent()
    Dim i, cRequired
	Dim fFileSpecified
	Dim fScriptSpecified

	fScriptSpecified = FALSE
	fFileSpecified = FALSE
    cRequired = 6   'number of required parameters
        
    If cArgs < cRequired Then
        Usage
        Exit Sub
    End If
        
    'Reset aPropValues array
    For i = 0 To cPropNames - 1
        aPropValues(i) = ""
    Next

    'Required parameters -----------------------
    aPropValues(ndxEventMethod) = obArgs.Item(1)
    aPropValues(ndxSinkClass) = obArgs.Item(2)
    aPropValues(ndxScope) = obArgs.Item(3)
    aPropValues(ndxTimerStartTime) = obArgs.Item(4)
    aPropValues(ndxTimerInterval) = obArgs.Item(5)

    'Process optional parameters
    For i = cRequired To cArgs - 1
        Select Case LCase(obArgs.Item(i))
            Case "-e"
                AddOptional ndxTimerExpireTime, i
			Case "-file"
				If fScriptSpecified Then
					Usage
					Exit Sub
				End If
				AddOptional ndxScriptUrl, i
				fFileSpecified = TRUE
				fScriptSpecified = TRUE
            Case "-url"
				If fScriptSpecified Then
					Usage
					Exit Sub
				End If
                AddOptional ndxScriptUrl, i
				fScriptSpecified = TRUE
        End Select
    Next

    'Call main registration routine
    AddNewStoreEvent fFileSpecified
End Sub

'=============================================================================='
' This routine is used to register the startup and shutdown events
'
' add eventmethod sinkclass eventbindingurl
'=============================================================================='
Sub RegisterStartStopEvent()
    Dim i, cRequired

    cRequired = 4   'number of required parameters
        
    If cArgs < cRequired Then
        Usage
        Exit Sub
    End If

    'Reset aPropValues array
    For i = 0 To cPropNames - 1
        aPropValues(i) = ""
    Next

    'Required parameters ---------------------
    aPropValues(ndxEventMethod) = obArgs.Item(1)
    aPropValues(ndxSinkClass) = obArgs.Item(2)
    aPropValues(ndxScope) = obArgs.Item(3)

    'Process optional parameters
    For i = cRequired To cArgs - 1
        Select Case LCase(obArgs.Item(i))
			Case "-file"
				' This option is not supported on startup shutdown event
				Usage
				Exit Sub
            Case "-url"
				' This option is not supported on startup shutdown event
				Usage
				Exit Sub
        End Select
    Next
                                
    AddNewStoreEvent FALSE
End Sub


        
'========================================================================================================'
' This routine is used to register the events in public and private store
'
' add eventmethod sinkclass eventbindingurl -m matchscope -p priority -f filter [<-url ScriptUrl> | <-file ScriptFile>]
'========================================================================================================'
Sub RegisterStoreEvent()
    Dim i, cRequired
	Dim fFileSpecified
	Dim fScriptSpecified

	fScriptSpecified = FALSE
	fFileSpecified = FALSE
    cRequired = 4   'number of required parameters
	
    If cArgs < cRequired Then
        Usage
        Exit Sub
    End If

    'Reset aPropValues array
    For i = 0 To cPropNames - 1
        aPropValues(i) = ""
    Next

    'Required parameters ---------------------
    aPropValues(ndxEventMethod) = obArgs.Item(1)
    aPropValues(ndxSinkClass) = obArgs.Item(2)
    aPropValues(ndxScope) = obArgs.Item(3)

    'Process optional parameters
    For i = cRequired To cArgs - 1
        Select Case LCase(obArgs.Item(i))
            Case "-m"
                AddOptional ndxMatchScope, i

            Case "-p"
                AddOptional ndxPriority, i

            Case "-f"
                AddOptional ndxCriteria, i

			Case "-file"
				If fScriptSpecified Then
					Usage
					Exit Sub
				End If
				AddOptional ndxScriptUrl, i
				fFileSpecified = TRUE
				fScriptSpecified = TRUE

            Case "-url"
				If fScriptSpecified Then
					Usage
					Exit Sub
				End If
                AddOptional ndxScriptUrl, i
				fScriptSpecified = TRUE

        End Select
    Next
                                
    AddNewStoreEvent fFileSpecified
End Sub

        
'=============================================================================='
' This subroutine creates the event binding in the meta-database
' by writing non-empty values passed in aPropValues array.
'=============================================================================='
Private Sub AddNewStoreEvent(fFileSpecified)
    On Error Resume Next
   
    Dim i
    Dim cn
    Dim rEvent
    Dim strEvent
    Dim strGuid
	Dim strBaseUrl
	Dim strEventRegistrationName
	Dim objStream

    strEvent = obArgs.Item(3)
	' Separate the event folder from the event registration name	
	SeperateParentFldFromEvtRegName strEvent, strBaseUrl, strEventRegistrationName
 
    Set cn = CreateObject("ADODB.Connection")
    Set rEvent = CreateObject("ADODB.Record")

	' Create the connection
    cn.Provider = "exoledb.datasource"
    cn.ConnectionString = strBaseUrl
    cn.Open
	If Err.Number <> 0 Then
		WScript.Echo "Error Opening Connection : " & Err.Number & " " & Err.Description & vbCrLf
		Exit Sub
	End If
    
    cn.BeginTrans
    rEvent.Open strEvent, cn, 3, 0     ' adModeReadWrite, adCreateNonCollection
	If Err.Number <> 0 Then
		WScript.Echo "Error Opening Record : " & Err.Number & " " & Err.Description & vbCrLf
		Exit Sub
	End If

	If fFileSpecified Then
		Set objStream = CreateObject("ADODB.Stream")

		objStream.Open rEvent, , 4		' adOpenStreamFromRecord
		If Err.Number <> 0 Then
			WScript.Echo "Error Opening Stream on Record : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If

		objStream.Charset = "ascii"
		objStream.LoadFromFile aPropValues(ndxScriptUrl)
		If Err.Number <> 0 Then
			WScript.Echo "Error Loading Stream From File : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If

		objStream.Close
		If Err.Number <> 0 Then
			WScript.Echo "Error Closing Stream On File : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If

		' get the DAV:href for the binding. The script url is now the binding url itself
		' as we have streamed in the file to the event binding
		aPropValues(ndxScriptUrl) = rEvent.Fields.Item("DAV:href").Value
	End If

	aPropValues(ndxContentClass) = "urn:content-class:storeeventreg"
    With rEvent.Fields
		' Add the binding properties======================
		For i = BeginBindingProps To EndBindingProps
			If aPropValues(i) <> "" Then
				.Item(aPropNames(i)) = aPropValues(i)
				If Err.Number <> 0 Then
					WScript.Echo "Error Adding " & aPropShortNames(i) & " : " & Err.Number & " " & Err.Description & vbCrLf
					Exit Sub
				End If
			End If
		Next

		'Add Sink props =============================
		For i = BeginSinkProps to EndSinkProps
			If aPropValues(i) <> "" Then
				.Item(aPropNames(i)) = aPropValues(i)
				If Err.Number <> 0 Then
					WScript.Echo "Error Adding " & aPropShortNames(i) & " : " & Err.Number & " " & Err.Description & vbCrLf
					Exit Sub
				End If
			End If
		Next
				
		WScript.Echo "New Event Binding created:" & vbCrLf & "Event: " & aPropValues(ndxEventMethod) & vbCrLf & "Sink:  " & aPropValues(ndxSinkClass) & vbCrLf & "FullBindingUrl: " & strEvent & vbCrLf

        .Update
		If Err.Number <> 0 Then
			WScript.Echo "Error Updating Props : " & Err.Number & " " & Err.Description & vbCrLf
			Exit Sub
		End If

    End With

    cn.CommitTrans
	If Err.Number <> 0 Then
		WScript.Echo "Error Commiting Transaction : " & Err.Number & " " & Err.Description & vbCrLf
		Exit Sub
	End If

End Sub

'=============================================================================='
' This function builds the SELECT query. If the event registration name is specified then
' it queries only for that event resource in the parent folder else it queries for all 
' event registrations in the parent folder
'=============================================================================='
Function BuildQueryString(strParentFolder, strEventRegistrationName, ByRef strQuery)
	Dim i

    strQuery = "SELECT "
    For i = LBound(aPropNames) To UBound(aPropNames)
        strQuery = strQuery + Chr(34) + aPropNames(i) + Chr(34)
        If i <> UBound(aPropNames) Then
            strQuery = strQuery + ", "
        End If
    Next
    strQuery = strQuery + " FROM SCOPE('shallow traversal of " + Chr(34) + strParentFolder + Chr(34) + "')"
    strQuery = strQuery + " WHERE " + Chr(34) + "DAV:contentclass" + Chr(34) + " = 'urn:content-class:storeeventreg'"
	If strEventRegistrationName <> "" Then
		' event folder name specified
		strQuery = strQuery + " AND " + Chr(34) + "DAV:displayname" + Chr(34) + " = '" + strEventRegistrationName + "'"
	End If
End Function

'=============================================================================='
' This routine separates the parent folder name from the full url if required
'=============================================================================='
Function SeparateBindingUrl(ByRef strParentFolder, ByRef strEventRegistrationName)
	SeparateBindingUrl = true
	If cArgs = 2 Then
		' the full url to the event binding is specified. Get the parent folder url from the specified url
		SeperateParentFldFromEvtRegName obArgs.Item(1), strParentFolder, strEventRegistrationName
	
	ElseIf cArgs = 3 And LCase(obArgs.Item(2)) = "all" Then
		' The specified url is the parent folder url
		strParentFolder = obArgs.Item(1)
		strEventRegistrationName = ""
	
	Else
		Usage
		SeparateBindingUrl = false
		Exit Function
	End If

End Function

'==========================================================================================='
' This routine separates the parent folder name and event registration name from the full url
'==========================================================================================='
Sub SeperateParentFldFromEvtRegName (strUrl, strParentFolder, strEventRegistrationName)
	Dim cLastSlash
	Dim cLastBackSlash
	Dim cDemarcate
	Dim cOtherHalf

	cLastSlash = InStrRev(strUrl, "/")
	cLastBackSlash = InStrRev(strUrl, "\")
	If cLastSlash > cLastBackSlash Then
		cDemarcate = cLastSlash
	Else
		cDemarcate = cLastbackSlash
	End If

	cOtherHalf = Len(strUrl) - cDemarcate
	strParentFolder = Left(strUrl, (cDemarcate-1))
	strEventRegistrationName = Right(strUrl, cOtherHalf)
End Sub
	
'=============================================================================='
' This routine displays the script parameters with examples
'=============================================================================='
Sub Usage()
     
    WScript.Echo "Usage: cscript RegEvent.vbs <add|delete|enum> <Args>" & vbCrLf
    WScript.Echo "-- Properties ---------------------------"
    WScript.Echo "Store EventMethod = OnSave;OnDelete;OnSyncSave;OnSyncDelete;OnSyncLock;OnSyncUnlock"
	WScript.Echo "System EventMethod = OnTimer;OnMdbStartUp;OnMDBShutDown"
    WScript.Echo "SinkClass   = ProgID of sink"
    WScript.Echo "EventItemUrl= Fully qualified URL of the event binding(registration msg)"
    WScript.Echo "Priority    = 0 (max) to 2147483647 (0x7FFFFFFF) (min). Default = 65535(0xffff). Only decimal values supported."
    WScript.Echo "MatchScope  = DEEP | SHALLOW | EXACT | ANY"
    WScript.Echo "ScriptFileUrl = Full (file or url) path of the script"
    WScript.Echo "CriteriaFilter = WHERE clause to restrict binding notifications"
    WScript.Echo "StartTime      = When to start the OnTimer event ""8/4/98 01:50:00 AM """
    WScript.Echo "ExpiryTime     = When to stop the OnTimer event"
    WScript.Echo "Interval       = Time between each OnTimer event"
    WScript.Echo ""
    
    WScript.Echo "-- Add command --------------------------"
    WScript.Echo "For StoreEvents"
    WScript.Echo "  Add EventMethod SinkClass EventItemUrl [-p Priority] [-m MatchScope] [-f CriteriaFilter] [<-url ScriptUrl> | <-file ScriptFile>]"
    WScript.Echo "For OnTimerEvent"
    WScript.Echo "  Add OnTimer SinkClass EventItemUrl StartTime Interval [-e ExpiryTime] [<-url ScriptUrl> | <-file ScriptFile>]"
    WScript.Echo "For StartUp ShutDown Event"
    WScript.Echo "  Add  SystemEventMethod SinkClass EventItemUrl"
    WScript.Echo "Note that -url or -file option is not supported for startup shutdown events"
    WScript.Echo ""

    WScript.Echo "-- Delete command -----------------------"
    WScript.Echo "delete scope [all]: delete the specified event registration or all event registrations in the parent folder"
    WScript.Echo ""

    WScript.Echo "-- Enum command -------------------------"
    WScript.Echo "enum scope [all]  : enum the specified event registration or all event registrations in the parent folder"
    WScript.Echo ""

    WScript.Echo "-- Examples -----------------------------"
    WScript.Echo "cscript RegEvent.vbs add ""onsave;ondelete"" sink1.sink1.1 file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox/evtreg1 -p 100 -m deep -file d:\test.vbs"
    WScript.Echo "cscript RegEvent.vbs add onsyncsave sink.sink.1 ""file://backofficestorage/exchange.microsoft.com/public folders/eventfolder/evtreg2"" -f ""WHERE $DAV:ishidden$ = FALSE"""
    WScript.Echo "cscript RegEvent.vbs add ontimer sink1.sink1.1 file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox/evtreg3 ""8/4/98 01:50:00 AM"" 1 -e ""8/4/98 02:25:00 AM"" -url ""file://./backofficestorage/kte-nt5.extest.microsoft.com/mbx/user1/inbox/eventscript.vbs"""
    WScript.Echo "cscript RegEvent.vbs add onMDBstartup sink1.sink1.1 file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox/evtreg4"
    WScript.Echo "cscript RegEvent.vbs delete file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox/evtreg3"
    WScript.Echo "cscript RegEvent.vbs delete file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox all"
    WScript.Echo "cscript RegEvent.vbs enum file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox/evtreg3"
    WScript.Echo "cscript RegEvent.vbs enum file://./backofficestorage/exchange.microsoft.com/mbx/user1/inbox all"
    WScript.Echo "   NOTE : The StartTime and ExpiryTime should be in Coordinated Universal" & vbCrLf & "   Time (CUT) format which is 4(or 5) hours ahead of Eastern Standard Time (EST)"
    WScript.Echo "   NOTE : Use $ for double quote("") in the CriteriaFilter"
End Sub
