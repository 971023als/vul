rem windows server script edit 2020
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ������ ������ ��û�մϴ�...
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
echo ------------------------------------------W-11------------------------------------------
ECHO ------------------------------------------USER_PW---------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\ 
FOR /F "tokens=1" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%j | find "Account active" | findstr "Yes" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		net user %%j | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		net user %%j | find "Password last set" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
FOR /F "tokens=2" %%y IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%y | find "Account active" | findstr "Yes" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		net user %%y | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		net user %%y | find "Password last set" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
FOR /F "tokens=3" %%b IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%b | find "Account active" | findstr "Yes" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		net user %%b | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		net user %%b | find "Password last set" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
cd "%install_path%"
ECHO ------------------------------------------USER_PW---------------------------------------
FOR /F "tokens=3" %%Y in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| find "MaximumPasswordAge" ^| findstr -v "Parameters"') DO set MaximumPasswordAge=%%Y
IF "%MaximumPasswordAge%" LSS "91" (
	REM ��ȣ
	echo W-11,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� ��ȣ ��� �Ⱓ�� 90�� ���Ϸ� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� ��ȣ ��� �Ⱓ[MaximumPasswordAge]�� 90�� ���Ϸ� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | find "MaximumPasswordAge" | findstr -v "Parameters" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���������� �����ߴ� ����[Password last set] Ȯ��  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_pw.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� ��ȣ ��� �Ⱓ�� 90�� ���Ϸ� �����Ǿ� �����Ƿ� ��ȣ��  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-11,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� ��ȣ ��� �Ⱓ�� 90�� ���Ϸ� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� ��ȣ ��� �Ⱓ[MaximumPasswordAge]�� 90�� �̻� �� ������ �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | find "MaximumPasswordAge" | findstr -v "Parameters" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���������� �����ߴ� ����[Password last set] Ȯ��  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_pw.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� ��ȣ ��� �Ⱓ�� 90�� ���Ϸ� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------

echo --------------------------------------W-10------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordLength">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt