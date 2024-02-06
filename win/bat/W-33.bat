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
echo ------------------------------------------W-32------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	FOR /F "tokens=1 delims=#" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http_path.txt') DO (
		cd %%a
		echo -----------------------�ش� ���͸�--------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls %%a /T | findstr /I "Everyone"
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls %%a /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------exe--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.exe /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.exe /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------dll--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.dll /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.dll /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------cmd--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.cmd /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.cmd /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------pl--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.pl /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.pl /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------asp--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.asp /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.asp /T  >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------inc--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.inc /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.inc /T  >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------shtm--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.shtm /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.shtm /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------shtml--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.shtml /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.shtml /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------txt--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.txt /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.txt /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------gif--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.gif /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.gif /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------jpg--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.jpg /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.jpg /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
		echo -----------------------html--------------------------->> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		cacls *.html /T | findstr /I "Everyone"
		REM ���
		IF NOT ERRORLEVEL 1 (
		REM ���
			cacls *.html /T >> C:\Window_%COMPUTERNAME%_raw\W-32.txt
		) ELSE (
		REM ��ȣ
			ECHO.
		)
	)
	cd "%install_path%"
	type C:\Window_%COMPUTERNAME%_raw\W-32.txt | findstr /I "Everyone" >> C:\Window_%COMPUTERNAME%_raw\W-32-1.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-32-1.txt
		REM ���
	IF NOT ERRORLEVEL 1 (
		REM ����
		echo W-32,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ȩ ���͸� ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ȩ ���͸� ���� �ִ� ���� ���ϵ� �� Everyone ������ �������� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ȩ ���͸� ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM �ٸ�   
		echo W-32,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ȩ ���͸� ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\W-32.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ȩ ���͸� ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-32,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
