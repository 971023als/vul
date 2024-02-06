@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한이 필요합니다...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "getadmin.vbs"
    "getadmin.vbs"
	del "getadmin.vbs"
    exit /B

:gotAdmin
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------Setting---------------------------------------
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\W-Window-*.txt
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt  0
cd >> C:\Window_%COMPUTERNAME%_raw\install_path.txt
for /f "tokens=2 delims=:" %%y in ('type C:\Window_%COMPUTERNAME%_raw\install_path.txt') do set install_path=c:%%y 
systeminfo >> C:\Window_%COMPUTERNAME%_raw\systeminfo.txt
echo ------------------------------------------IIS Setting-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" >> C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
set "line="
for /F "delims=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\iis_path1.txt') do (
set "line=!line!%%a" 
)
echo !line!>>C:\Window_%COMPUTERNAME%_raw\line.txt
for /F "tokens=1 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
	echo %%a >> C:\Window_%COMPUTERNAME%_raw\path1.txt
)
for /F "tokens=2 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
	echo %%a >> C:\Window_%COMPUTERNAME%_raw\path2.txt
)
for /F "tokens=3 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
	echo %%a >> C:\Window_%COMPUTERNAME%_raw\path3.txt
)
for /F "tokens=4 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
	echo %%a >> C:\Window_%COMPUTERNAME%_raw\path4.txt
)
for /F "tokens=5 delims=*" %%a in ('type C:\Window_%COMPUTERNAME%_raw\line.txt') do (
	echo %%a >> C:\Window_%COMPUTERNAME%_raw\path5.txt
)
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
echo ------------------------------------------end-------------------------------------------
echo ------------------------------------------W-27------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
IF NOT ERRORLEVEL 1 (
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | find "ObjectName" | find "LocalSystem" > nul
	IF NOT ERRORLEVEL 1 (
		echo W-27,N/A,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo IISADMIN 서비스가 LocalSystem 계정으로 실행되지 않으므로 특별한 조치가 필요하지 않습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 해당 설정은 보안에 영향을 줄 수 있는 중요한 설정이며, LocalSystem 계정 대신 더 제한적인 권한을 가진 계정을 사용하는 것이 권장됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		echo W-27,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo IISADMIN 서비스가 LocalSystem 계정으로 실행됩니다. 이는 권장되지 않습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 보안을 강화하려면, IISADMIN 서비스를 더 제한적인 권한을 가진 계정으로 실행하도록 변경해야 합니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | find "ObjectName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	echo W-27,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo World Wide Web Publishing Service가 실행되지 않고 있습니다. IIS 관련 보안 설정을 검토할 필요가 없습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end-------------------------------------------

echo --------------------------------------W-27------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC" | FINDSTR /L "ObjectName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | FINDSTR /L "ObjectName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------localgroup Administrators---------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup Administrators>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

