rem windows server script edit 2020
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
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
echo ------------------------------------------W-03------------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\
net user | find /v "successfully" | find /v "User" >> user.txt 
FOR /F "tokens=1" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%j | find "Account active" | findstr "Yes" >nul 
REM 양호
	IF NOT ERRORLEVEL 1 (
	REM 양호
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		net user %%j | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		net user %%j | find "Account active" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
FOR /F "tokens=2" %%y IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%y | find "Account active" | findstr "Yes" >nul 
REM 양호
	IF NOT ERRORLEVEL 1 (
	REM 양호
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		net user %%y | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		net user %%y | find "Account active" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
FOR /F "tokens=3" %%b IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%b | find "Account active" | findstr "Yes" >nul 
REM 양호
	IF NOT ERRORLEVEL 1 (
	REM 양호
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		net user %%b | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		net user %%b | find "Account active" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
cd "%install_path%"
type C:\Window_%COMPUTERNAME%_raw\user_info.txt | findstr /I "test guest" >nul 
REM 취약
IF NOT ERRORLEVEL 1 (
	REM 취약
	echo W-03,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ■ 기준 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 불필요한 계정이 존재하지 않는 경우 양호 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ■ 현황 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 활성화 되어있는 계정 중 test, Guest 계정이 존재하므로 취약함 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_info.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ■ 설명 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo test 계정이 포함되어있으므로 취약함 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM 양호
	echo W-03,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ■ 기준 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 불필요한 계정이 존재하지 않는 경우 양호 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ■ 현황 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_info.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ■ 설명 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 인터뷰를 통해 불필요한 계정이 존재하면 취약으로 판단예정 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------

echo --------------------------------------W-03------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net user | find /V "successfully">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
