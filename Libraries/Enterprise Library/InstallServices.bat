@echo off
@REM  ---------------------------------------------------------------------------------
@REM  InstallServices.bat file
@REM  Alterado a partir do Original e preparado para o OWNet install setup
@REM  ----------------------------------------------------------------------------------

set mFrameworkDir="C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322\installutil.exe"
set ownetBinDir=C:\Inetpub\wwwroot\OWNet5\bin

@ECHO.
@ECHO -----------------------------------------------------------------
@ECHO Installing Services for the Common Application Block
@ECHO -----------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Common.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Common.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO -----------------------------------------------------------------
@ECHO Installing Services for the Caching Application Block
@ECHO -----------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Caching.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Caching.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO -----------------------------------------------------------------
@ECHO Installing Services for the ConfigurationApplication Block
@ECHO -----------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Configuration.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Configuration.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO -----------------------------------------------------------------
@ECHO Installing Services for the Cryptography Application Block
@ECHO -----------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Security.Cryptography.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Security.Cryptography.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO -----------------------------------------------------------------
@ECHO Installing Services for the Data Access Application Block
@ECHO -----------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Data.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Data.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO -----------------------------------------------------------------------
@ECHO Installing Services for the Exception Handling Application Block
@ECHO -----------------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.ExceptionHandling.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.ExceptionHandling.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO ---------------------------------------------------------------------------------
@ECHO Installing Services for the Logging and Instrumentation Application Block
@ECHO ---------------------------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Logging.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Logging.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO -----------------------------------------------------------------
@ECHO Installing Services for the Security Application Block
@ECHO -----------------------------------------------------------------
@ECHO.

if Exist Microsoft.Practices.EnterpriseLibrary.Security.dll @call %mFrameworkDir% %ownetBinDir%\Microsoft.Practices.EnterpriseLibrary.Security.dll
@if errorlevel 1 goto :error

@ECHO.
@ECHO ----------------------------------------
@ECHO InstallServices.bat Completed
@ECHO ----------------------------------------
@ECHO.

@REM  ----------------------------------------
@REM  Restore the command prompt and exit
@REM  ----------------------------------------
@goto :exit

@REM  -------------------------------------------
@REM  Handle errors
@REM
@REM  Use the following after any call to exit
@REM  and return an error code when errors occur
@REM
@REM  if errorlevel 1 goto :error	
@REM  -------------------------------------------
:error
@ECHO An error occured in InstallServices.bat - %errorLevel%
if %pause%==true PAUSE
@exit errorLevel

@REM  ----------------------------------------
@REM  The exit label
@REM  ----------------------------------------
:exit
echo on

