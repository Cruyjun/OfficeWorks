REM Instalação da assembly na GAC
REM Kill do processo do ASPNET

echo off

cd "C:\windows\Microsoft.NET\Framework\v1.1.4322"

gacutil.exe /i "C:\proj\EPWebControls\EPWebControls WKS\bin\Release\EP.Web.UI.WebControls.dll"

"C:\proj\EPWebControls\EPWebControls WKS\install\pskill.exe" aspnet_wp.exe

pause