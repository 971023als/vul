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
echo ------------------------------------------W-01------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr "NewAdministratorName" | findstr /R "\<Administrator" >nul 
REM ���
IF NOT ERRORLEVEL 1 ( 
	REM ���
	echo W-01,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Administrator Default ���� �̸��� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "����: Administrator ���� �̸� �ٲٱ�" ��å ������ administrator�� ���� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr "NewAdministratorName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Administrator Default ���� �̸��� ����Ǿ����� �ʱ� ������ ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ��ȣ
	NET USER | FIND "Administrator" >nul 
	REM ���
	IF NOT ERRORLEVEL 1 ( 
		REM ���
		echo W-01,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Administrator Default ���� �̸��� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� ���� �� Administrator �����̸��� ����ϰ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		NET USER | FIND "Administrator" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Administrator Default ���� �̸��� ����Ǿ����� �ʱ� ������ ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE ( 
		REM ��ȣ
		echo W-01,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Administrator Default ���� �̸��� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Administrator Default ���� �̸��� ��å �� �������� �߰ߵ��� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Administrator Default ���� �̸��� ��å �� �������� ����Ǿ��ֱ� ������ ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) 
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-02------------------------------------------
net user guest > NUL
IF NOT ERRORLEVEL 1 (
	net user guest | find "Account active" | findstr "No" >nul 
	REM ��ȣ
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ
		echo W-02,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Guest ������ ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Guest ������ ���������� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net user guest | find "User name" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net user guest | find "Account active" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Guest ������ ��Ȱ��ȭ �Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE ( 
		REM ���
		echo W-02,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Guest ������ ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Guest ������ �����ϰ� Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net user guest | find "User name" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net user guest | find "Account active" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Guest ������ Ȱ��ȭ �Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE ( 
	REM ���
	echo W-02,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Guest ������ ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Guest ������ �������� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Guest ������ ������������ ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-03------------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\
net user | find /v "successfully" | find /v "User" >> user.txt 
FOR /F "tokens=1" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%j | find "Account active" | findstr "Yes" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
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
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
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
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
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
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-03,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Ȱ��ȭ �Ǿ��ִ� ���� �� test, Guest ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_info.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo test ������ ���ԵǾ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ��ȣ
	echo W-03,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_info.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ͺ並 ���� ���ʿ��� ������ �����ϸ� ������� �Ǵܿ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-04------------------------------------------
for /f "tokens=3" %%a in ('net accounts ^| find "Lockout threshold"') do set threshold=%%a
REM ��ȣ
if "%threshold%" GTR "5" (
	REM ��ȣ
	echo W-04,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���� ��� �Ӱ谪�� 5 ������ ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���� �Ӱ谪[Lockout threshold]�� 5 �̻��� ������ �����Ǿ�����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	net accounts | find "Lockout threshold" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���� ��� �Ӱ谪�� 5 �̻��� ������ �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ���
	net accounts | find "Lockout threshold" | findstr /I "Never" >nul
	REM ��ȣ
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ
		echo W-04,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ��� �Ӱ谪�� 5 ������ ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� �Ӱ谪[Lockout threshold]�� �����Ǿ����� ����[never] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net accounts | find "Lockout threshold" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ��� �Ӱ谪�� �����Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE ( 
		REM ���
		echo W-04,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ��� �Ӱ谪�� 5 ������ ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� �Ӱ谪[Lockout threshold]�� 5 ���Ϸ� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net accounts | find "Lockout threshold" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ��� �Ӱ谪�� 5������ ������ �����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-05------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ClearTextPassword" | findstr "0" >nul 
REM 0(������), 1(�����) ��ȣ
IF NOT ERRORLEVEL 1 (
	REM ��ȣ 
	echo W-05,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å�� "��� ����" ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å[ClearTextPassword]�� "��� ����"[0]���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ClearTextPassword" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å�� "��� ����"���� �����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-05,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å�� "��� ����" ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å[ClearTextPassword]�� "���"[1]���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ClearTextPassword" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å�� "�����"���� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-06------------------------------------------
net localgroup Administrators | findstr "test Guest" >nul 
REM ���
IF NOT ERRORLEVEL 1 (
	REM ��� 
	echo W-06,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Administrators �׷쿡 ���ʿ��� ������ ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �׷쿡 test �� Guest ������ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	net localgroup Administrators | findstr /V "Comment Members completed" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Administrators �׷쿡 TEST���� �� Guest������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ��ȣ
	echo W-06,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Administrators �׷쿡 ���ʿ��� ������ ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	net localgroup Administrators | findstr /V "Comment Members completed" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ͺ並 ���� Administrators �׷쿡 ���ʿ��� ������ �����ϸ� ������� �Ǵܿ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-07------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymou" | findstr "0" > nul
REM ��ȣ
IF NOT ERRORLEVEL 1 (
	REM ��ȣ 
	echo W-07,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "Everyone ��� ������ �͸� ����ڿ��� ����" ��å�� "��� ����" ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "Everyone ��� ������ �͸� ����ڿ��� ����" ��å[EveryoneIncludesAnonymou]�� "��� ����"[0]���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymou" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "Everyone ��� ������ �͸� ����ڿ��� ����" ��å�� "��� ����" ���� �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-07,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "Everyone ��� ������ �͸� ����ڿ��� ����" ��å�� "��� ����" ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "Everyone ��� ������ �͸� ����ڿ��� ����" ��å[EveryoneIncludesAnonymou]�� "���"[1]���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymou" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "Everyone ��� ������ �͸� ����ڿ��� ����" ��å�� "�����" ���� �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-08------------------------------------------
for /f "tokens=3" %%a in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| Find /I "LockoutDuration"') do set LockoutDuration=%%a
for /f "tokens=3" %%b in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| Find /I "ResetLockoutCount"') do set ResetLockoutCount=%%b
if "%ResetLockoutCount%" GTR "59" (
	if "%LockoutDuration%" GTR "59" (
		REM ��ȣ
		echo W-08,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ" �� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 60�� �̻��� ������ ������ �ǰ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ"[LockoutDuration] �� "���� ��� �Ⱓ ������� ���� �Ⱓ"[ResetLockoutCount] �� 60�� �̻����� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LockoutDuration" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ResetLockoutCount" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ" �� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ���
		echo W-08,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ" �� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 60�� �̻��� ������ ������ �ǰ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ"[LockoutDuration] �� 60�� ���Ϸ� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ ������� ���� �Ⱓ"[ResetLockoutCount] �� 60�� �̻����� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LockoutDuration" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ResetLockoutCount" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ" �� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ���
	echo W-08,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ" �� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 60�� �̻��� ������ ������ �ǰ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "���� ��� �Ⱓ"[LockoutDuration] �� "���� ��� �Ⱓ ������� ���� �Ⱓ"[ResetLockoutCount] �� 60�� ���Ϸ� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LockoutDuration" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ResetLockoutCount" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ" �� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ���� ���� ������ ���� ��� ������ �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-09------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "PasswordComplexity" | findstr "1" > nul
IF NOT ERRORLEVEL 1 (
	REM ��ȣ 
	echo W-09,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "���"���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ȣ�� ���⼺�� �����ؾ� ��" ��å[PasswordComplexity]�� "���"[1]���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "PasswordComplexity" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "���"���� �Ǿ� ���� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-09,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "���"���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ȣ�� ���⼺�� �����ؾ� ��" ��å[PasswordComplexity]�� "��� �� ��"[0]���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "PasswordComplexity" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "��� �� ��"���� �Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-10------------------------------------------
FOR /F "tokens=3" %%J in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| Find /I "MinimumPasswordLength"') DO set MinimumPasswordLength=%%J
IF "%MinimumPasswordLength%" GTR "7" (
	REM ��ȣ
	echo W-10,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ���̰� ���� 8�̻����� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ����[MinimumPasswordLength]�� ���� 8�̻����� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordLength">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ���̰� ���� 8�̻����� �����Ǿ� �����Ƿ� ��ȣ��  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-10,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ���̰� ���� 8�̻����� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ����[MinimumPasswordLength]�� ���� 8�������� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordLength">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ���̰� ���� 8�̻����� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
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
echo ------------------------------------------W-12------------------------------------------
FOR /F "tokens=3" %%B in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| Find /I "MinimumPasswordAge"') DO set MinimumPasswordAge=%%B
IF "%MinimumPasswordAge%" GTR "0" (
	REM ��ȣ 
	type C:\Window_%COMPUTERNAME%_raw\user_pw.txt | findstr /I "2012 2013 2014 2015" > nul
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ 
		echo W-12,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ּ� ��ȣ ��� �Ⱓ[MinimumPasswordAge]�� 0���� ū ������ �����Ǿ� ������ ������ �����ߴ� ��¥ Ȯ�� ��� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordAge">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ּ� ��ȣ ��� �Ⱓ[MinimumPasswordAge]�� 0���� ū ������ �����Ǿ� ������ ������ �����ߴ� ��¥ Ȯ�� ��� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE ( 
		REM ���
		echo W-12,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ּ� ��ȣ ��� �Ⱓ[MinimumPasswordAge]�� 0���� ū ������ �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordAge">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� �����Ƿ� ��ȣ��  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE ( 
	REM ���
	echo W-12,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ��� �Ⱓ[MinimumPasswordAge]�� 0���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordAge">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-13------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName" | findstr "1" > nul
IF NOT ERRORLEVEL 1 (
	REM ��ȣ 
	echo W-13,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "������ ����� �̸� ǥ�� �� ��" ��å�� "���" ���� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "������ ����� �̸� ǥ�� �� ��" ��å[DontDisplayLastUserName]�� "���"[1]���� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "������ ����� �̸� ǥ�� �� ��" ��å�� "���" ���� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-13,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "������ ����� �̸� ǥ�� �� ��" ��å�� "���" ���� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "������ ����� �̸� ǥ�� �� ��" ��å[DontDisplayLastUserName]�� "��� �� ��"[0]���� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "������ ����� �̸� ǥ�� �� ��" ��å�� "���" ���� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-14------------------------------------------
echo W-14,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ���� �α׿� ��� ��å�� Administrators, IUSR_�� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ���� �α׿� ��� ��å[SeInteractiveLogonRight]�� Administrators, IUSR_�� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN-LOCAL-GROUP  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\ADMINISTRATORS     S-1-5-32-544                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\USERS              S-1-5-32-545                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\GUESTS             S-1-5-32-546                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\ACCOUNT OPERATORS  S-1-5-32-548                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\SERVER OPERATORS   S-1-5-32-549                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\PRINT OPERATORS    S-1-5-32-550                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\BACKUP OPERATORS   S-1-5-32-551                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\REPLICATOR         S-1-5-32-552 												>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- 												>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- 												>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ���ͺ並 ���� ���ʿ��� ������ �����ϸ� ������� �Ǵܿ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-15------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup" | findstr "0" > nul
REM ��ȣ
IF NOT ERRORLEVEL 1 (
	REM ��ȣ 
	echo W-15,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�͸� SID/�̸� ��ȯ ���" ��å�� "��� ����" ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�͸� SID/�̸� ��ȯ ���" ��å[LSAAnonymousNameLookup]�� "��� ����"[0] ���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�͸� SID/�̸� ��ȯ ���" ��å�� "��� ����" ���� �Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-15,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�͸� SID/�̸� ��ȯ ���" ��å�� "��� ����" ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�͸� SID/�̸� ��ȯ ���" ��å[LSAAnonymousNameLookup]�� "���"[1] ���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�͸� SID/�̸� ��ȯ ���" ��å�� "��� ��" ���� �Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-16------------------------------------------
FOR /F "tokens=3" %%O in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| find "PasswordHistorySize"') DO set PasswordHistorySize=%%O
IF %PasswordHistorySize% GTR 11 (
	REM ��ȣ
	echo W-16,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֱ� ��ȣ ����� 12�� �̻����� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֱ� ��ȣ ���[PasswordHistorySize]�� 12�� �̻����� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | find "PasswordHistorySize" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֱ� ��ȣ ����� 12�� �̻����� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ��� 
	echo W-16,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֱ� ��ȣ ����� 12�� �̻����� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֱ� ��ȣ ���[PasswordHistorySize]�� 12�� ���Ϸ� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | find "PasswordHistorySize" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֱ� ��ȣ ����� 12�� ���Ϸ� �����Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-17------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse" | findstr "1" > nul
REM ��ȣ
IF NOT ERRORLEVEL 1 (
	REM ��ȣ 
	echo W-17,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å[LimitBlankPasswordUse]�� "���"[1]���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"���� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ���
	echo W-17,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å[LimitBlankPasswordUse]�� "��� �� ��"[0]���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "��� �� ��"���� �����Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-18------------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\ 
FOR /F "tokens=1" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%j | find "Remote Desktop Users" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		net user %%j | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		net user %%j | find "Remote Desktop Users" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
FOR /F "tokens=2" %%y IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%y | find "Remote Desktop Users" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		net user %%y | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		net user %%y | find "Remote Desktop Users" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
FOR /F "tokens=3" %%b IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%b | find "Remote Desktop Users" >nul 
REM ��ȣ
	IF NOT ERRORLEVEL 1 (
	REM ��ȣ
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		net user %%b | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		net user %%b | find "Remote Desktop Users" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
		echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt 
	) ELSE (
		ECHO.
	)
)
ECHO.
cd "%install_path%"
type C:\Window_%COMPUTERNAME%_raw\user_Remote.txt | findstr /I "test Guest" > nul
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-18,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���������� ������ ������ �����Ͽ� Ÿ ������� ���������� �����ϰ�, �������� ����� �׷쿡 ���ʿ��� ������ ��ϵǾ� ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���������� ������ �������� test, Guest ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_Remote.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ͺ並 ���� ���ʿ��� ������ �����ϸ� ������� �Ǵܿ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-18,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���������� ������ ������ �����Ͽ� Ÿ ������� ���������� �����ϰ�, �������� ����� �׷쿡 ���ʿ��� ������ ��ϵǾ� ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\user_Remote.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ��� ���� ���� ��� �������� ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ͺ並 ���� ���ʿ��� ������ �����ϸ� ������� �Ǵܿ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-19------------------------------------------
net share | find /v "$" | find /v "command" | find /v "-" > C:\Window_%COMPUTERNAME%_raw\W-19.txt
FOR /F "tokens=2" %%j IN (C:\Window_%COMPUTERNAME%_raw\W-19.txt) DO (
cacls %%j>> C:\Window_%COMPUTERNAME%_raw\W-19-1.txt
)
type C:\Window_%COMPUTERNAME%_raw\W-19-1.txt | Find /I "Everyone" > nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���  
	echo W-19,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ϲ� ���� ���͸��� ���ų� ���� ���͸� ���� ���ѿ� Everyone ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ϲ� ���� ���͸����� Everyone ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-19-1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ϲ� ���� ���͸����� Everyone ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ��ȣ
	echo W-19,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ϲ� ���� ���͸��� ���ų� ���� ���͸� ���� ���ѿ� Everyone ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ϲ� ���� ���͸��� Everyone ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ϲ� ���� ���͸��� Everyone ������ �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-20------------------------------------------
net share | FIND /V "IPC$" | FIND /V "ADMIN" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]" > nul
REM ��� 
IF NOT ERRORLEVEL 1 (
	REM ���  
	echo W-20,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo AutoShareServer�� 0�̸� �⺻ ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �⺻ ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	net share | FIND /V "IPC$" | FIND /V "ADMIN" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �⺻ ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
	REM ��ȣ
	reg query HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters | FIND /I "AutoShareServer" | FIND /I "0x0" > nul
	REM ��ȣ
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ
		echo W-20,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo AutoShareServer�� 0�̸� �⺻ ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo AutoShareServer�� 0�̰ų� �⺻ ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters | FIND /I "AutoShareServer" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �⺻ ���� ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo AutoShareServer�� 0�̸� �⺻ ������ �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE ( 
		REM ���
		echo W-20,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo AutoShareServer�� 0�̸� �⺻ ������ �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo AutoShareServer�� 0�� �ƴϰų� �⺻������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �⺻ ������ �������� ������ AutoShareServer ������Ʈ�� ���� 0���� �����Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-21------------------------------------------
net start | findstr /I "Alerter ClipBook Messenger">> C:\Window_%COMPUTERNAME%_raw\W-21.txt
net start | find /I "Simple TCP/IP Services">> C:\Window_%COMPUTERNAME%_raw\W-21.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-21.txt
REM ��ȣ
IF NOT ERRORLEVEL 1 (
	REM ��ȣ
	echo W-21,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ���� "Alerter, ClipBook, Messenger, Simple TCP/IP Services"�� �����Ǿ��ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���ʿ��� ���񽺰� �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ���� "Alerter, ClipBook, Messenger, Simple TCP/IP Services"�� �����Ǿ��ֹǷ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ���
	echo W-21,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ���� "Alerter, ClipBook, Messenger, Simple TCP/IP Services"�� �����Ǿ��ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ���� "Alerter, ClipBook, Messenger, Simple TCP/IP Services"�� Ȱ��ȭ �Ǿ�����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-21.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� ���� "Alerter, ClipBook, Messenger, Simple TCP/IP Services"�� �������̹Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-22------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
find C:\Window_%COMPUTERNAME%_raw\path*.txt "http" | find "http">> C:\Window_%COMPUTERNAME%_raw\http.txt
for /f "delims=" %%x in ('type C:\Window_%COMPUTERNAME%_raw\http.txt') do set "token=%%x"
:NextLine_http
for /F "delims=^> tokens=1,*" %%I in ("!token!") do (
   echo %%I >> C:\Window_%COMPUTERNAME%_raw\http2.txt
   echo.
   set "token=%%J"
   if not "!token!"=="" goto NextLine_http
   GOTO END
)
:END
FOR /F "tokens=3 delims=^=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http2.txt') DO (
	ECHO %%a >> C:\Window_%COMPUTERNAME%_raw\http3.txt
)
FOR /F "tokens=1 delims=/" %%x IN ('type C:\Window_%COMPUTERNAME%_raw\http3.txt') DO (
	set V=%%x
	call set V=%%V:"=!%% 
	echo %%x >> C:\Window_%COMPUTERNAME%_raw\http4.txt
	echo %V%
	FOR /F "tokens=1 delims=!" %%G IN ('call echo %%V%%') DO (
		ECHO "%%G"#>> C:\Window_%COMPUTERNAME%_raw\http5.txt
	)
)
FOR /F "tokens=1 delims=/" %%c IN ('type C:\Window_%COMPUTERNAME%_raw\http5.txt') DO (
	ECHO %%c >> C:\Window_%COMPUTERNAME%_raw\http_path1.txt
)
type C:\Window_%COMPUTERNAME%_raw\http_path1.txt | find /v "ECHO" >> C:\Window_%COMPUTERNAME%_raw\http_path.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-22,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ����[World Wide Web Publishing Service]�� Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	net start | find "World Wide Web Publishing Service" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO IIS ���񽺰� Ȱ��ȭ �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-22,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ����[World Wide Web Publishing Service]�� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ��ֹǷ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-23------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	FOR /F "tokens=1 delims=#" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http_path.txt') DO (
		cd %%a
		type web.config | find "directoryBrowse" | find "true" >> C:\Window_%COMPUTERNAME%_raw\W-23.txt
		type web.config >> C:\Window_%COMPUTERNAME%_raw\IIS_WEB_CONFIG.txt
	)
	cd "%install_path%"
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-23.txt
		REM ��ȣ
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ
		echo W-23,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���͸� �˻�"�� üũ�Ǿ� ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���͸� �˻�"�� üũ�Ǿ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "���͸� �˻�"�� üũ�Ǿ� ���� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ���
		type C:\Window_%COMPUTERNAME%_raw\W-23.txt | find "directoryBrowse" > nul
		IF NOT ERRORLEVEL 1 (
			REM ��ȣ 
			echo W-23,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo "���͸� �˻�"�� üũ�Ǿ� ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			TYPE C:\Window_%COMPUTERNAME%_raw\W-23.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo "���͸� �˻�"�� üũ�Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ���
			echo W-23,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo "���͸� �˻�"�� üũ�Ǿ� ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ��� ���� ������ �����Ƿ� ���͸� �˻� ����� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-25.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ��� ���� ������ �����Ƿ� ���͸� �˻� ����� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	)
) ELSE (
	REM ��ȣ
	echo W-23,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-24------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	IF EXIST C:\inetpub\scripts (
		echo C:\inetpub\scripts >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
		cacls C:\inetpub\scripts | FIND "Everyone" | find "F" >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
		cacls C:\inetpub\scripts | FIND "Everyone" | find "C" >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
		echo ------------------------------------------- >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
	) ELSE (
		IF EXIST C:\inetpub\cgi-bin (
			echo C:\inetpub\cgi-bin >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
			cacls C:\inetpub\cgi-bin | FIND "Everyone" | find "F" >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
			cacls C:\inetpub\cgi-bin | FIND "Everyone" | find "C" >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
			echo ------------------------------------------- >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
		) ELSE (
			type C:\Window_%COMPUTERNAME%_raw\compare.txt >> C:\Window_%COMPUTERNAME%_raw\W-24.txt
		)
	)
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-24.txt
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ 
		echo W-24,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� ���͸� Everyone�� ������, ��������, ��������� �ο����� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� ���͸� Everyone�� ������, ��������, ��������� �ο����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo cgi-bin, scripts ���͸��� Everyone�� ������, ��������, ��������� �ο����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ���
		echo W-24,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� ���͸� Everyone�� ������, ��������, ��������� �ο����� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� ���͸�[cgi-bin, scripts] Everyone�� ������ �ο��Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\W-24.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo cgi-bin, scripts ���͸��� Everyone�� ������, ��������, ������� �� �ο��Ǿ������Ƿ� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ
	echo W-24,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-25------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | find /I "asp enableParentPaths">> C:\Window_%COMPUTERNAME%_raw\W-25.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-25.txt
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ 
		echo W-25,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� �н� ����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� �н� ����� �����ϰ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo applicationHost.Config ���Ͽ� ���� ���� �������� �����Ƿ� ����Ʈ�� ���� ������ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� �н� ����� �����ϰ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		type C:\Window_%COMPUTERNAME%_raw\W-25.txt | find /I "enableParentPaths=""false""" > nul
		IF NOT ERRORLEVEL 1 (
			REM ��ȣ 
			echo W-25,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �н� ����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �н� ����� �����ϰ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-25.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �н� ����� �����ϰ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ���
			echo W-25,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �н� ����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �н� ����� �����ϰ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-25.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �н� ����� �����ϰ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	)
) ELSE (
	REM ��ȣ
	echo W-25,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-26------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	IF EXIST "c:\program files\common files\system\msadc\sample" (
		echo c:\program files\common files\system\msadc\sample >> C:\Window_%COMPUTERNAME%_raw\W-26.txt
	) ELSE (
		IF EXIST "c:\winnt\help\iishelp" (
			echo c:\winnt\help\iishelp >> C:\Window_%COMPUTERNAME%_raw\W-26.txt
		) ELSE (
			IF EXIST "c:\inetpub\iissamples" (
				echo c:\inetpub\iissamples >> C:\Window_%COMPUTERNAME%_raw\W-26.txt
			) ELSE (
				IF EXIST "%SystemRoot%\System32\Inetsrv\IISADMPWD" (
					echo %SystemRoot%\System32\Inetsrv\IISADMPWD >> C:\Window_%COMPUTERNAME%_raw\W-26.txt
				) ELSE (
					type C:\Window_%COMPUTERNAME%_raw\compare.txt >> C:\Window_%COMPUTERNAME%_raw\W-26.txt
				)
			)
		)
	)
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-26.txt
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ 
		echo W-26,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� �� ����Ʈ�� IISsample, IISHelp, IISADMPWD ���� ���͸��� �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� �� ����Ʈ�� IISsample, IISHelp, IISADMPWD ���� ���͸��� �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� �� ����Ʈ�� IISsample, IISHelp, IISADMPWD ���� ���͸��� �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ���
		echo W-26,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� �� ����Ʈ�� IISsample, IISHelp, IISADMPWD ���� ���͸��� �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� �� ����Ʈ�� IISsample, IISHelp, IISADMPWD �� ���� ���͸��� ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\W-26.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ش� �� ����Ʈ�� IISsample, IISHelp, IISADMPWD ���� ���͸��� �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-26,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-27------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | find "ObjectName" | find "LocalSystem" > nul
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-27,N/A,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���μ����� �� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���μ����� �� ���� ��� �ʿ��� �ּ��� ������ �ƴ� "���� �ý��� ����"���� �����Ǿ�����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | find "ObjectName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���μ����� �� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ� ���� �����Ƿ� ��������� Windows Server 2012�� ��� ���� �� ���� ���۵��� ���� �� �����Ƿ� ����ó�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� �ý��� ���� �н����� ����[���⼺ �� �н����� ���� �ֱ�]�� �ǰ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		echo W-27,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���μ����� �� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���μ����� �� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ�����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | find "ObjectName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���μ����� �� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-27,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-28------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	FOR /F "tokens=1 delims=#" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http_path.txt') DO (
	cd %%a	
	ATTRIB /s | findstr ".lnk"  >> C:\Window_%COMPUTERNAME%_raw\W-28.txt  
	)
	cd "%install_path%"
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-28.txt
	REM �Ȱ����� ��ȣ, �ٸ��� ��� 
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ
		echo W-28,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ���Ǿ����� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ���Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ���
		type C:\Window_%COMPUTERNAME%_raw\W-28.txt | findstr ".lnk" >nul
		IF NOT ERRORLEVEL 1 (
			REM ��ȣ
			echo W-28,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �ش� Ȩ ���͸��� ��ũ ������ ������  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-28.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ���Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ���
			echo W-28,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ���Ǿ����� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ���Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	)
) ELSE (
	REM ��ȣ
	echo W-28,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-29------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	FOR /F "tokens=1 delims=#" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http_path.txt') DO (
		cd %%a
		type web.config | find /I "maxAllowedContentLength" >> C:\Window_%COMPUTERNAME%_raw\W-29.txt
	)
	cd "%install_path%"
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-29.txt
	REM �Ȱ����� ��ȣ, �ٸ��� ��� 
	IF NOT ERRORLEVEL 1 (
		echo W-29,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���ν��� ���� �ڿ� ������ ���� ���ε� �� �ٿ�ε� �뷮�� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ������ �뷮[maxAllowedContentLength] ������ �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ������ �뷮[maxAllowedContentLength] ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ
		type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find /I "bufferingLimit">> C:\Window_%COMPUTERNAME%_raw\W-29-raw1.txt
		ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-29-raw1.txt
		REM �Ȱ����� ��ȣ, �ٸ��� ���
		IF NOT ERRORLEVEL 1 (
			REM ���
			echo W-29,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���ν��� ���� �ڿ� ������ ���� ���ε� �� �ٿ�ε� �뷮�� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �ٿ�ε� �뷮[bufferingLimit] ������ �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� �ٿ�ε� �뷮[bufferingLimit] ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find /I "maxRequestEntityAllowed">> C:\Window_%COMPUTERNAME%_raw\W-29-raw2.txt
			ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-29-raw2.txt
			REM �Ȱ����� ��ȣ, �ٸ��� ���
			IF NOT ERRORLEVEL 1 (
				REM ���
				echo W-29,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���ν��� ���� �ڿ� ������ ���� ���ε� �� �ٿ�ε� �뷮�� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ���� ���ε� �뷮[maxRequestEntityAllowed] ������ �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ���� ���ε� �뷮[maxRequestEntityAllowed] ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			) ELSE (
				REM ��ȣ
				echo W-29,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���ν��� ���� �ڿ� ������ ���� ���ε� �� �ٿ�ε� �뷮�� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ���� ���ε� �뷮[maxRequestEntityAllowed] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ���� �ٿ�ε� �뷮[bufferingLimit] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ������ �뷮[maxAllowedContentLength] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				type C:\Window_%COMPUTERNAME%_raw\W-29-raw2.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				type C:\Window_%COMPUTERNAME%_raw\W-29-raw1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				type C:\Window_%COMPUTERNAME%_raw\W-29.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���ν��� ���� �ڿ� ������ ���� ���ε� �� �ٿ�ε� �뷮�� ���� ������ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			)
		)
	)
) ELSE (
	REM ��ȣ
	echo W-29,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-30------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr /I ".asax asax" >> C:\Window_%COMPUTERNAME%_raw\W-30.txt
	type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr /I ".asa asa" >> C:\Window_%COMPUTERNAME%_raw\W-30.txt
	type C:\Window_%COMPUTERNAME%_raw\W-30.txt | findstr /I """.asa"""
	IF NOT ERRORLEVEL 1 (
		type C:\Window_%COMPUTERNAME%_raw\W-30.txt | findstr /I """.asax"""
		IF NOT ERRORLEVEL 1 (
			type C:\Window_%COMPUTERNAME%_raw\W-30.txt | findstr /I "allowed=""false"""
			IF NOT ERRORLEVEL 1 (
				REM ����
				echo W-30,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo .asa, .asax ������ �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo .asa, .asax ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				type C:\Window_%COMPUTERNAME%_raw\W-30.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo .asa, .asax ������ �����ϹǷ� ��ȣ��>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			) ELSE (
				rem �ٸ�
				echo W-30,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo .asa, .asax ������ �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo .asa, .asax ������ ���������� ������ true������ ���� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo .asa, .asax ������ ���������� ������ true������ ���� �Ǿ������Ƿ� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
				echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			)
		) ELSE (
			rem �ٸ�
			echo W-30,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo .asa, .asax ������ �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo .asax ������ �������� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-30.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo .asax ������ �������ϹǷ� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
		rem �ٸ�
		echo W-30,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo .asa, .asax ������ �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo .asa, .asax ������ �������� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo .asa, .asax ������ �������ϹǷ� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-30,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-31------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-31,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� �� ����Ʈ�� IIS Admin, IIS Adminpwd ���� ���͸��� �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� IIS 6.0�̻� ���� �ش� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� ����� IIS 6.0 �̻��̹Ƿ� �ش� �׸� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� ����� IIS 6.0 �̻��̹Ƿ� �ش� �׸� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ   
	echo W-31,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
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
echo ------------------------------------------W-33------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr /L ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> C:\Window_%COMPUTERNAME%_raw\W-33.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-33.txt
		REM ���
	IF NOT ERRORLEVEL 1 (
		REM ����
		echo W-33,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ����� ����".htr .idc .stm .shtm .shtml .printer .htw .ida .idq"�� �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ����� ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ����� ����".htr .idc .stm .shtm .shtml .printer .htw .ida .idq"�� �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM �ٸ�
		echo W-33,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ����� ����".htr .idc .stm .shtm .shtml .printer .htw .ida .idq"�� �������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ����� ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\W-33.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ����� ����".htr .idc .stm .shtm .shtml .printer .htw .ida .idq"�� �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-33,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-34------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-34,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS 5.0 �������� �ش� ������Ʈ�� ���� 0�̰ų� ���� IIS 6.0�̻��� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� ����� IIS 6.0 �̻��̹Ƿ� �ش� �׸� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� ����� IIS 6.0 �̻��̹Ƿ� �ش� �׸� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ   
	echo W-34,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-35------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	TYPE C:\Windows\System32\inetsrv\config\applicationHost.config | findstr /I "description=""webdav""" | findstr /I "allowed=""False""" >> C:\Window_%COMPUTERNAME%_raw\W-35-1.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-35-1.txt 
	IF NOT ERRORLEVEL 1 (
	REM ���
		REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s | find /I "DisableWebDAV" | find /I "1">> C:\Window_%COMPUTERNAME%_raw\W-35.txt
		ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-35.txt
		REM ��� 
		IF NOT ERRORLEVEL 1 (
			REM ����
			echo W-35,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ���� �� �� ������ �ش��ϴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 1. IIS ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 2. DisableWebDAV ���� 1�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 3. Windows NT, 2000�� ������ 4 �̻��� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 4. Windows 2003, Windows 2008�� WebDAV�� ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo DisableWebDAV���� �����Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM �ٸ�
			echo W-35,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ���� �� �� ������ �ش��ϴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 1. IIS ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 2. DisableWebDAV ���� 1�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 3. Windows NT, 2000�� ������ 4 �̻��� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 4. Windows 2003, Windows 2008�� WebDAV�� ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s | find /I "DisableWebDAV" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo DisableWebDAV���� �����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
	REM ��ȣ
	echo W-35,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� �� ������ �ش��ϴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 1. IIS ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 2. DisableWebDAV ���� 1�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 3. Windows NT, 2000�� ������ 4 �̻��� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 4. Windows 2003, Windows 2008�� WebDAV�� ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo WebDAV�� ���� �Ǿ��ְų� ��Ȱ��ȭ �Ǿ�����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo WebDAV�� ���� �Ǿ��ְų� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ��>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-35,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-36------------------------------------------
REG QUERY HKLM\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces /S | findstr "NetbiosOptions" >> C:\Window_%COMPUTERNAME%_raw\W-36.txt
TYPE C:\Window_%COMPUTERNAME%_raw\W-36.txt | findstr "NetbiosOptions" | findstr /L "0x2" > nul
REM ��ȣ
IF NOT ERRORLEVEL 1 (
	REM ��ȣ
	echo W-36,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NetbiosOptions ���� 0�̸� �⺻�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NetbiosOptions ���� 1�̸� NetBIOS over TCP ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NetbiosOptions ���� 2�̸� NetBIOS over TCP ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	REG QUERY HKLM\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces /S | findstr "NetbiosOptions" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ���
	echo W-36,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NetbiosOptions ���� 0�̸� �⺻�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NetbiosOptions ���� 1�̸� NetBIOS over TCP ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NetbiosOptions ���� 2�̸� NetBIOS over TCP ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	REG QUERY HKLM\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces /S | findstr "NetbiosOptions" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-37------------------------------------------
net start | find /I "Microsoft FTP Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���   
	echo W-37,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Microsoft FTP Service ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	net start | find /I "Microsoft FTP Service" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� Ȱ��ȭ �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	rem ================== ftp =================
	cd C:\Windows\System32\inetsrv
	dir | find /I "appcmd.exe" >nul
		IF NOT ERRORLEVEL 1 (
			appcmd list config >> C:\Window_%COMPUTERNAME%_raw\ftp_config.txt
			appcmd list config | find "virtualDirectory path" >> C:\Window_%COMPUTERNAME%_raw\ftp_path1.txt
			FOR /F "tokens=3 delims=^=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\ftp_path1.txt') DO (
				ECHO %%a >> C:\Window_%COMPUTERNAME%_raw\ftp_path.txt
			)
		) else (
			echo "c:\inetpub\ftproot" >> C:\Window_%COMPUTERNAME%_raw\ftp_path.txt
		)
	rem ================== ftp-end =================
) ELSE (
	REM ��ȣ   
	net start | find /I "FTP Publishing Service" >nul
	REM ���
	IF NOT ERRORLEVEL 1 (
		REM ���   
		echo W-37,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Microsoft FTP Service ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP ���񽺰� Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		net start | find /I "FTP Publishing Service" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP ���񽺰� Ȱ��ȭ �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		rem ================== ftp =================
		cd C:\Windows\System32\inetsrv
		dir | find /I "appcmd.exe" >nul
		IF NOT ERRORLEVEL 1 (
			appcmd list config >> C:\Window_%COMPUTERNAME%_raw\ftp_config.txt
			appcmd list config | find "virtualDirectory path" >> C:\Window_%COMPUTERNAME%_raw\ftp_path1.txt
			FOR /F "tokens=3 delims=^=" %%a in ('type C:\Window_%COMPUTERNAME%_raw\ftp_path1.txt') DO (
				ECHO %%a >> C:\Window_%COMPUTERNAME%_raw\ftp_path.txt
			)
		) else (
			echo "c:\inetpub\ftproot" >> C:\Window_%COMPUTERNAME%_raw\ftp_path.txt
		)
		rem ================== ftp-end =================
	) ELSE (
		REM ��ȣ   
		echo W-37,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Microsoft FTP Service ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-38------------------------------------------
cd "C:\Window_%COMPUTERNAME%_raw\"
dir | find /I "ftp_path.txt" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	FOR /F "tokens=1 delims=/" %%a in ('type C:\Window_%COMPUTERNAME%_raw\FTP_PATH.txt') DO (
		cacls %%a >> C:\Window_%COMPUTERNAME%_raw\w-38-1.txt
		cacls %%a | findstr /I "Everyone" >> C:\Window_%COMPUTERNAME%_raw\w-38.txt
	)
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\w-38.txt
	REM ���
	IF NOT ERRORLEVEL 1 (
		REM ����  
		echo W-38,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP Ȩ ���͸��� EVERYONE ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP Ȩ ���͸��� EVERYONE ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP Ȩ ���͸��� EVERYONE ������ �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM �ٸ�
		echo W-38,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP Ȩ ���͸��� EVERYONE ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP Ȩ ���͸��� EVERYONE ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		TYPE C:\Window_%COMPUTERNAME%_raw\w-38.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP Ȩ ���͸��� EVERYONE ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-38,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Microsoft FTP Service ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-39------------------------------------------
cd "C:\Window_%COMPUTERNAME%_raw\"
dir | find /I "ftp_path.txt" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ��� 
	TYPE C:\Window_%COMPUTERNAME%_raw\ftp_config.txt | find /i "anonymousAuthentication enabled=""true"""  >> C:\Window_%COMPUTERNAME%_raw\w-39.txt
	REM ��� 
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\w-39.txt
	IF NOT ERRORLEVEL 1 (
		REM ����
		echo W-39,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP ���񽺸� ������� �ʰų�, ���͸� ���� ��롱�� üũ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "�͸� ���� ���" �� üũ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "�͸� ���� ���" �� üũ���� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM �ٸ�  
		echo W-39,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo FTP ���񽺸� ������� �ʰų�, ���͸� ���� ��롱�� üũ���� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\w-39.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		TYPE C:\WINDOWS\system32\inetsrv\MetaBase.xml | findstr /i "IIsFtpService IIsFtpServer AllowAnonymous="  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ���� ���� ��� default�� �͸� ���� ����� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "�͸� ���� ���" �� üũ�Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ   
	echo W-39,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Microsoft FTP Service ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-40------------------------------------------
cd "C:\Window_%COMPUTERNAME%_raw\"
dir | find /I "ftp_path.txt" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	TYPE C:\WINDOWS\system32\inetsrv\MetaBase.xml | findstr /i "IIsFtpService IIsFtpVirtualDir IPSecurity=" | find /I "0102" >> C:\Window_%COMPUTERNAME%_raw\w-40-1.txt
	REM ���
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\w-40-1.txt
	IF NOT ERRORLEVEL 1 (
		REM ���� 
		echo W-40,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ư�� IP�ּҿ����� FTP������ �����ϵ��� �������� ������ ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �⺻����[� ������ �Ǿ����� ����]���� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM �ٸ�
		echo W-40,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ư�� IP�ּҿ����� FTP������ �����ϵ��� �������� ������ ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\w-40-1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\w-40.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ    
	echo W-40,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Microsoft FTP Service ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-41------------------------------------------
net start | find /I "DNS SERVER" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" | find "0x2"  >> C:\Window_%COMPUTERNAME%_raw\w-41.txt
	REM ���
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\w-41.txt
	IF NOT ERRORLEVEL 1 (
		REM ���� 
		echo W-41,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �Ʒ� ���ؿ� �ش��ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 1 DNS ���񽺸� ������� ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 2 ���� ���� ����� ���� ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 3 Ư�� �����θ� ������ �Ǿ����� ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �⺻�������� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �⺻�������� �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM �ٸ�
		echo W-41,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �Ʒ� ���ؿ� �ش��ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 1 DNS ���񽺸� ������� ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 2 ���� ���� ����� ���� ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 3 Ư�� �����θ� ������ �Ǿ����� ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\w-41.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO Ư�� IP �ּ� ������ �Ǿ��־� Ư�� �����θ� ������ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ    
	echo W-41,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS ���񽺸� ������� ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS ���񽺰� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-42------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
IF NOT ERRORLEVEL 1 (
	echo W-42,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���� �� �� ������ �ش�Ǵ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 1. IIS�� ������� �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 2. Windows 2000 ������ 4, Windows 2003 ������ 2 �̻� ��ġ�Ǿ� �ִ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 3. ����Ʈ �� ����Ʈ�� MSADC ���� ���͸��� �������� �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 4. �ش� ������Ʈ�� ���� �������� �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 5. ���� ����� Windows Server 2012 �̻��� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� ����� ����������� 2012 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���� 2008�̹Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ    
	echo W-42,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���� �� �� ������ �ش�Ǵ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 1. IIS�� ������� �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 2. Windows 2000 ������ 4, Windows 2003 ������ 2 �̻� ��ġ�Ǿ� �ִ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 3. ����Ʈ �� ����Ʈ�� MSADC ���� ���͸��� �������� �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 4. �ش� ������Ʈ�� ���� �������� �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 5. ���� ����� Windows Server 2012 �̻��� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-43------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\systeminfo.txt | FIND "OS Version" >> C:\Window_%COMPUTERNAME%_raw\W-43.txt
echo W-43,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �ֽ� �������� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �ǰ��ϴ� �������� ��ġ�Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
type C:\Window_%COMPUTERNAME%_raw\W-43.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �ǰ��ϴ� �������� ��ġ�Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-44------------------------------------------
FOR /F "tokens=2 delims=x" %%G in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" ^| findstr "MinEncryptionLevel"') DO set MEL=%%G
IF "%MEL%" GTR "1" (
	echo W-44,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �͹̳� ���񽺸� ������� �ʰų� ��� �� ��ȣȭ ������ ��Ŭ���̾�Ʈ�� ȣȯ ���ɡ� �̻����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �͹̳� ���񽺸� ��������� ��� �� ��ȣȭ ������ ��Ŭ���̾�Ʈ�� ȣȯ ���ɡ� �̻����� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x1 ^= ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x2 ^= Ŭ���̾�Ʈ ȣȯ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x3 ^= ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x4 ^= FIPS �԰� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr "MinEncryptionLevel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �͹̳� ���񽺸� ��������� ��ȣȭ ������ ���ȼ����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	echo W-44,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �͹̳� ���񽺸� ������� �ʰų� ��� �� ��ȣȭ ������ ��Ŭ���̾�Ʈ�� ȣȯ ���ɡ� �̻����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �͹̳� ���񽺸� ��������� ��� �� ��ȣȭ ������ ��Ŭ���̾�Ʈ�� ȣȯ ���ɡ� �̻����� �����Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x1 ^= ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x2 ^= Ŭ���̾�Ʈ ȣȯ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x3 ^= ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo MinEncryptionLevel ���� 0x4 ^= FIPS �԰� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr "MinEncryptionLevel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �͹̳� ���񽺸� ��������� ��ȣȭ ������ ���ȼ����Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-45------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM ���
IF NOT ERRORLEVEL 1 (
	FOR /F "tokens=1 delims=#" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http_path.txt') DO (
		cd %%a
		type web.config >> C:\Window_%COMPUTERNAME%_raw\W-45.txt
	)
	type C:\Window_%COMPUTERNAME%_raw\W-45.txt | find /I "error statusCode" >> C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt
	IF NOT ERRORLEVEL 1 (
		REM ���
		type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | find /I "%SystemDrive%\inetpub\custerr\" >> C:\Window_%COMPUTERNAME%_raw\W-45-RAW2.txt
		ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-45-RAW2.txt
		IF NOT ERRORLEVEL 1 (
			REM ���
			echo W-45,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� ���� �������� ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� ���� �������� ������ �����Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ======= �� ���� ���������� ======= >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ======= �� ���� ���������� ======= >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-45-RAW2.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt			
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� ���� �������� ������ �����Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ��ȣ    
			echo W-45,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� ���� �������� ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� ����Ʈ ���� �������� ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ======= �� ���� ���������� ======= >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | FIND /I "error statusCode" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ���� ����Ʈ ���� �������� ������ �����ϹǷ� ��ȣ��>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
		REM ��ȣ    
		echo W-45,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� ���� �������� ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ����Ʈ ���� �������� ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO ======= �� ���� ���������� ======= >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���� ����Ʈ ���� �������� ������ �����ϹǷ� ��ȣ��>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ    
	echo W-45,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� ���� �������� ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo IIS ���񽺰� Ȱ��ȭ �Ǿ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-46------------------------------------------
net start | findstr /I "SNMP" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-46,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� Ȱ��ȭ �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ    
	echo W-46,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-47------------------------------------------
net start | findstr /I "SNMP" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities | findstr /I "public private"
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-47,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SNMP ���񽺸� ������� �ʰų� Community �̸��� public, private�� �ƴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SNMP ���񽺸� ������̸� Community �̸��� public, private�� ����ϰ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities | findstr /I "public private" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ������ public, private�� SNMP ���� Community�� ����ϰ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ    
		reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities | find /I "REG_DWORD" >> C:\Window_%COMPUTERNAME%_raw\W-47.txt
		ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-47.txt
		IF NOT ERRORLEVEL 1 (
			REM ���
			echo W-47,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo SNMP ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo SNMP ���񽺸� ������̸� Community �̸��� public, private�� ������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ����ڰ� ������ SNMP ���� Community�� ����ϰ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ��ȣ    
			echo W-47,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo SNMP ���񽺸� ������� �ʰų� Community �̸��� public, private�� �ƴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo SNMP ���񽺸� ������̸� Community �̸������� �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo SNMP ���� Community �̸� ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	)
) ELSE (
	REM ��ȣ    
	echo W-47,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-48------------------------------------------
net start | findstr /I "SNMP" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers >> C:\Window_%COMPUTERNAME%_raw\W-48.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-48.txt
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-48,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� ������ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ    
		echo W-48,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ    
	echo W-48,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP ���񽺰� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-49------------------------------------------
net start | find /I "DNS SERVER" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr /I "AllowUpdate" | find /I "0x0"
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-49,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS ���񽺸� ������� �ʰų� ���� ������Ʈ ������������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS ���񽺸� ������� �ʰų� ���� ������Ʈ ������������ �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS ���񽺸� ������� �ʰų� ���� ������Ʈ ������������ �����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt	
	) ELSE (
		REM ��ȣ    
		echo W-49,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS ���񽺸� ������� �ʰų� ���� ������Ʈ ������������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS ���񽺸� ������� �ʰų� ���� ������Ʈ �����ȵ��� ���������� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS ���񽺸� ������� �ʰų� ���� ������Ʈ �����ȵ��� ���������� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ    
	echo W-49,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS ���񽺸� ������� �ʴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS ���񽺰� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-50------------------------------------------
echo W-50,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo HTTP, FTP, SMTP ���� �� ��� ������ ������ �ʴ� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ������ 2000�� �ش�� ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ������ 2000�� �ش������ Windows server 2012�� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-51------------------------------------------
reg query "HKLM\Software\Microsoft\TelnetServer" /s >nul
IF NOT ERRORLEVEL 1 (
	REM ��ȣ
	tlntadmn config | find /I "Authentication" | find /I "NTLM"
	IF NOT ERRORLEVEL 1 (
		REM ��ȣ
		tlntadmn config | find /I "Authentication" | find /I "Password"
		IF NOT ERRORLEVEL 1 (
			REM ��ȣ
			echo W-51,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo Telnet ���񽺰� ���� �Ǿ� ���� �ʰų� ���� ����� NTLM�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo Telnet ���񽺰� Ȱ��ȭ �Ǿ��ְ� ���� ����� NTLM ���� �����Ǿ��ְ� PASSWORD�� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			tlntadmn config | find /I "Authentication" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo Telnet ���񽺰� Ȱ��ȭ �Ǿ��ְ� ���� ����� NTLM, PASSWORD �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ��ȣ 
			echo W-51,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo Telnet ���񽺰� ���� �Ǿ� ���� �ʰų� ���� ����� NTLM�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo Telnet ���񽺰� Ȱ��ȭ �Ǿ������� ���� ����� NTLM�� ���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			tlntadmn config | find /I "Authentication" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo Telnet ���񽺰� Ȱ��ȭ �Ǿ������� ���� ����� NTLM�� ���� �����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
		REM ��ȣ 
		echo W-51,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Telnet ���񽺰� ���� �Ǿ� ���� �ʰų� ���� ����� NTLM�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Telnet ���񽺰� Ȱ��ȭ �Ǿ��ְ� ���� ����� NTLM ���� �����Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		tlntadmn config | find /I "Authentication" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Telnet ���񽺰� Ȱ��ȭ �Ǿ��ְ� ���� ����� NTLM ���� �����Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ 
	echo W-51,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Telnet ���񽺰� ���� �Ǿ� ���� �ʰų� ���� ����� NTLM�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Telnet ���񽺰� ��Ȱ��ȭ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Telnet ���񽺰� ��Ȱ��ȭ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-52------------------------------------------
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" >> C:\Window_%COMPUTERNAME%_raw\W-52.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-52.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-52,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ý��� DSN �κ��� Data Source�� ���� ����ϰ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������� �ʴ� ���ʿ��� ODBC ������ �ҽ� ���� �Ǿ�����  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������� �ʴ� ���ʿ��� ODBC ������ �ҽ� ���ŵǾ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-52,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ý��� DSN �κ��� Data Source�� ���� ����ϰ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������� �ʴ� ���ʿ��� ODBC ������ �ҽ� ���� �Ǿ����� ����  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" /S >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������� �ʴ� ���ʿ��� ODBC ������ �ҽ� ���ŵǾ� ���� �����Ƿ� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-53------------------------------------------
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /S | findstr /I /L "MaxIdleTime" | FIND /I "0x0"
IF NOT ERRORLEVEL 1 (
	REM ����
	echo W-53,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �������� �� Timeout ���� ������ ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Terminal ���񽺰� Ȱ��ȭ �Ǿ��ְ� Timeout ������� �Ǿ����� ����  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /S | findstr /I /L "MaxIdleTime" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Terminal ���񽺰� Ȱ��ȭ �Ǿ��ְ� Timeout ������� �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt		
) ELSE (
	REM ���� 
	echo W-53,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �������� �� Timeout ���� ������ ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Terminal ���񽺰� Ȱ��ȭ �Ǿ��ְ� Timeout ������� �Ǿ�����  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Terminal ���񽺰� Ȱ��ȭ �Ǿ��ְ� Timeout ������� �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-54------------------------------------------
at | FIND /V /L "There are no entries in the list" >> C:\Window_%COMPUTERNAME%_raw\W-54.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-54.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-54,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� �۾��� �����Ͽ� ���ʿ��� ���ɾ ������ �ִ��� Ȯ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� �۾��� ���ʿ��� ���ɾ ������ �������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� �۾��� ���ʿ��� ���ɾ ������ �������� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ����
	echo W-54,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� �۾��� �����Ͽ� ���ʿ��� ���ɾ ������ �ִ��� Ȯ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� �۾��� �����ϹǷ� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	at >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���ʿ��� �۾��� ������ �� �����Ƿ� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-55------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\systeminfo.txt | findstr /i "Hotfix KB" | find /i "3214628" > NUL
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-55,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֽ� Hotfix �Ǵ� PMS Agent�� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֽ� Hotfix �Ǵ� PMS Agent�� ��ġ�Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\systeminfo.txt | findstr /i "Hotfix KB" | find /i "3214628" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֽ� Hotfix �Ǵ� PMS Agent�� ��ġ�Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-55,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֽ� Hotfix �Ǵ� PMS Agent�� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֽ� Hotfix �Ǵ� PMS Agent�� ��ġ�Ǿ� �ִ��� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\systeminfo.txt | findstr /i "Hotfix KB" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ֽ� Hotfix �Ǵ� PMS Agent�� ��ġ�Ǿ� �ִ��� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-56------------------------------------------
reg query "HKLM\SOFTWARE\ESTsoft" /S >> C:\Window_%COMPUTERNAME%_raw\W-56.txt
reg query "HKLM\SOFTWARE\AhnLab" /S >> C:\Window_%COMPUTERNAME%_raw\W-56.txt 
TYPE C:\Window_%COMPUTERNAME%_raw\W-56.txt | Findstr /I "AhnLab ESTsoft" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-56,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷��� �ֽ� ���� ������Ʈ�� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷� ��ġ �Ǿ������� ���ͺ並 ���� �ֽ� ���� ������Ʈ Ȯ���ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-56.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷� ��ġ �Ǿ������� ���ͺ並 ���� �ֽ� ���� ������Ʈ Ȯ���ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-56,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷��� �ֽ� ���� ������Ʈ�� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� �׸��� ��ũ��Ʈ���� ������α׷� Ȯ���� ������� �����Ƿ� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-56.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� �׸��� ��ũ��Ʈ���� ������α׷� Ȯ���� ������� �����Ƿ� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-57------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditLogonEvents" | find /V "3" > C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditPrivilegeUse" | find /V "2" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditPolicyChange" | find /V "3" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditDSAccess" | find /V "2" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditAccountLogon" | find /V "3" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditAccountManage" | find /V "2" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt  C:\Window_%COMPUTERNAME%_raw\W-57.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-57,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ʒ��� ���� �̺�Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �α׿� �̺�Ʈ[AuditLogonEvents], ���� �α׿� �̺�Ʈ[AuditAccountLogon], ��å ����[AuditPolicyChange]: ����/���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� ����[AuditAccountManage], ���͸� ���� �׼���[AuditDSAccess], ���� ���[AuditPrivilegeUse]: ���� ���� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 0�̸� ������� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 1�̸� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 2�̸� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 3�̸� ����, ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �̺�Ʈ�� ���� ���� ������ �ǰ��ϰ��ִ� ������ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �̺�Ʈ�� ���� ���� ������ �ǰ��ϰ� �ִ� ������ �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-57,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �Ʒ��� ���� �̺�Ʈ�� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �α׿� �̺�Ʈ[AuditLogonEvents], ���� �α׿� �̺�Ʈ[AuditAccountLogon], ��å ����[AuditPolicyChange]: ����/���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� ����[AuditAccountManage], ���͸� ���� �׼���[AuditDSAccess], ���� ���[AuditPrivilegeUse]: ���� ���� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 0�̸� ������� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 1�̸� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 2�̸� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� �� ���� 3�̸� ����, ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-57.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �̺�Ʈ�� ���� ���� ������ �ǰ��ϰ� �ִ� ������ �ٸ��Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-58------------------------------------------
echo W-58,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �α� ��Ͽ� ���� ���������� ����, �м�, ����Ʈ �ۼ� �� ���� ���� ��ġ�� �̷������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �α� ��� ���� �� �м��� �����Ͽ� ����Ʈ�� �ۼ��ϰ� ���������� �����ϴ��� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �α� ��� ���� �� �м��� �����Ͽ� ����Ʈ�� �ۼ��ϰ� ���������� �����ϴ��� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-59------------------------------------------
net start | find /I "Remote Registry" >nul
IF NOT ERRORLEVEL 1 (
	REM ����
	echo W-59,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Remote Registry Service�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Remote Registry Service�� ����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Remote Registry Service�� ����Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ����
	echo W-59,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Remote Registry Service�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Remote Registry Service�� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Remote Registry Service�� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-60------------------------------------------
echo "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application" >> C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt
echo "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security" >> C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt
echo "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System" >> C:\Window_%COMPUTERNAME%_raw\W-60_System.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application" | find "MaxSize" | find /v "MaxSizeUpper">> C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security" | find "MaxSize" | find /v "MaxSizeUpper">> C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System" | find "MaxSize" | find /v "MaxSizeUpper">> C:\Window_%COMPUTERNAME%_raw\W-60_System.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application" | find "Retention" | find "0x0">> C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security" | find "Retention" | find "0x0">> C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System" | find "Retention" | find "0x0">> C:\Window_%COMPUTERNAME%_raw\W-60_System.txt
type C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt | find "Retention" | find "0x0" >> C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
type C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt | find "Retention" | find "0x0" >> C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
type C:\Window_%COMPUTERNAME%_raw\W-60_System.txt | find "Retention" | find "0x0" >> C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
type C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt | find "MaxSize" | find "0xa00000" >> C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
type C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt | find "MaxSize" | find "0xa00000" >> C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
type C:\Window_%COMPUTERNAME%_raw\W-60_System.txt | find "MaxSize" | find "0xa00000" >> C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\Eventlog.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-60,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� �α� ũ�� ��10,240Kb �̻����� ����, ��90�� ���� �̺�Ʈ ����� �� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� �α� ũ�� ��10,240Kb �̻����� ����, ��90�� ���� �̺�Ʈ ����� �� ������ �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-60_System.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� �α� ũ�� ��10,240Kb �̻����� ����, ��90�� ���� �̺�Ʈ ����� �� ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-60,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� �α� ũ�� ��10,240Kb �̻����� ����, ��90�� ���� �̺�Ʈ ����� �� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� �α� ũ�� ��10,240Kb �̻����� ����, ��90�� ���� �̺�Ʈ ����� �� ������ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-60_Application.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-60_Security.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\W-60_System.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ִ� �α� ũ�� ��10,240Kb �̻����� ����, ��90�� ���� �̺�Ʈ ����� �� ������ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-61------------------------------------------
cacls %systemroot%\system32\logfiles | FINDSTR /I "Everyone">> C:\Window_%COMPUTERNAME%_raw\W-61.txt
cacls %systemroot%\system32\config | FINDSTR /I "Everyone">> C:\Window_%COMPUTERNAME%_raw\W-61.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-61.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-61,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α� ���͸��� ���ѿ� Everyone ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α� ���͸��� ���ѿ� Everyone ������ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �α� ���͸��� ���ѿ� Everyone ������ �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-61,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α� ���͸��� ���ѿ� Everyone ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α� ���͸��� ���ѿ� Everyone ������ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-61.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �α� ���͸��� ���ѿ� Everyone ������ �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-62------------------------------------------
reg query "HKLM\SOFTWARE\ESTsoft" /S >> C:\Window_%COMPUTERNAME%_raw\W-62.txt
reg query "HKLM\SOFTWARE\AhnLab" /S >> C:\Window_%COMPUTERNAME%_raw\W-62.txt 
TYPE C:\Window_%COMPUTERNAME%_raw\W-62.txt | Findstr /I "AhnLab ESTsoft" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-62,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷��� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷� ��ġ �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-62.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷� ��ġ �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-62,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̷��� ��� ���α׷��� ��ġ�Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� �׸��� ��ũ��Ʈ���� ������α׷� Ȯ���� ������� �����Ƿ� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �ش� �׸��� ��ũ��Ʈ���� ������α׷� Ȯ���� ������� �����Ƿ� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-63------------------------------------------
cacls %systemroot%\system32\config\SAM | FIND /V /I "Administrator" | FIND /V /I "System" >> C:\Window_%COMPUTERNAME%_raw\W-63.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-63.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-63,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	TYPE C:\Window_%COMPUTERNAME%_raw\W-63.txt | FIND /I ":" >nul
	IF NOT ERRORLEVEL 1 (
		REM ����
		echo W-63,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		TYPE C:\Window_%COMPUTERNAME%_raw\W-63.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ����
		echo W-63,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 ��� �������� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-64------------------------------------------
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive" | findstr /I "1" >> C:\Window_%COMPUTERNAME%_raw\W-64-1.txt
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure" | findstr /I "1" >> C:\Window_%COMPUTERNAME%_raw\W-64-2.txt
for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\Desktop" ^| find "ScreenSaveTimeOut"') do set ScreenSaveTimeOut=%%a
REM ��ȣ
type C:\Window_%COMPUTERNAME%_raw\W-64-1.txt | find "1" > nul
IF NOT ERRORLEVEL 1 (
	type C:\Window_%COMPUTERNAME%_raw\W-64-2.txt | find "1" > nul
	IF NOT ERRORLEVEL 1 (
		if "%ScreenSaveTimeOut%" LSS "601" (
			REM ���
			echo W-64,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�⸦ �����ϰ� ��� �ð��� 10�� ������ ������ �����Ǿ� ������, ȭ�� ��ȣ�� ������ ���� ��ȣ�� ����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�⸦ ����[ScreenSaveActive]�ϰ� ��� �ð�[ScreenSaveTimeOut]�� 10�� ������ ������ �����Ǿ� ������, ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure]�� ����ϰ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�� ����[ScreenSaveActive] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure]���� ���� ��쿡 �̼��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ��� �ð�[ScreenSaveTimeOut] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveTimeOut" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�⸦ �����ϰ� ��� �ð��� 10�� ������ ������ �����Ǿ� ������, ȭ�� ��ȣ�� ������ ���� ��ȣ�� ����ϰ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ��ȣ 
			echo W-64,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�⸦ �����ϰ� ��� �ð��� 10�� ������ ������ �����Ǿ� ������, ȭ�� ��ȣ�� ������ ���� ��ȣ�� ����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�⸦ ����[ScreenSaveActive]�ϰ� ��� �ð�[ScreenSaveTimeOut]�� 10�� ������ ������ �����Ǿ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�� ����[ScreenSaveActive] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure]���� ���� ��쿡 �̼��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ��� �ð�[ScreenSaveTimeOut] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveTimeOut" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ȭ�� ��ȣ�⸦ ����[ScreenSaveActive]�ϰ� ��� �ð�[ScreenSaveTimeOut]�� 10�� ������ ������ �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
		REM ��ȣ 
		echo W-64,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȭ�� ��ȣ�⸦ �����ϰ� ��� �ð��� 10�� ������ ������ �����Ǿ� ������, ȭ�� ��ȣ�� ������ ���� ��ȣ�� ����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȭ�� ��ȣ�⸦ ����[ScreenSaveActive]�Ǿ��ְ� ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure]�� ����ϰ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȭ�� ��ȣ�� ����[ScreenSaveActive] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure]���� ���� ��쿡 �̼��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��� �ð�[ScreenSaveTimeOut] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveTimeOut" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȭ�� ��ȣ�⸦ �����ϰ� ȭ�� ��ȣ�� ������ ���� ��ȣ�� ����ϰ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ 
	echo W-64,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ȭ�� ��ȣ�⸦ �����ϰ� ��� �ð��� 10�� ������ ������ �����Ǿ� ������, ȭ�� ��ȣ�� ������ ���� ��ȣ�� ����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ȭ�� ��ȣ�⸦ ����[ScreenSaveActive]�� ����ϰ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ȭ�� ��ȣ�� ����[ScreenSaveActive] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ȭ�� ��ȣ�� ������ ���� ��ȣ[ScreenSaverIsSecure]���� ���� ��쿡 �̼��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ��� �ð�[ScreenSaveTimeOut] >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveTimeOut" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ȭ�� ��ȣ�⸦ ����[ScreenSaveActive]�� ����ϰ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-65------------------------------------------
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find /I "ShutdownWithoutLogon" | find "0x0"
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-65,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� ���� �ʰ� �ý��� ���� ��롱�� ����� �� �ԡ����� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� ���� �ʰ� �ý��� ���� ��롱[ShutdownWithoutLogon]�� ����� �� �ԡ����� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find /I "ShutdownWithoutLogon" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� ���� �ʰ� �ý��� ���� ��롱�� ����� �� �ԡ����� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-65,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� ���� �ʰ� �ý��� ���� ��롱�� ����� �� �ԡ����� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� ���� �ʰ� �ý��� ���� ��롱[ShutdownWithoutLogon]�� ����롱���� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find /I "ShutdownWithoutLogon" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� ���� �ʰ� �ý��� ���� ��롱�� ����롱���� �����Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-66------------------------------------------
for /F "tokens=3" %%A in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| Find /I "SeRemoteShutdownPrivilege"') do echo %%A >> C:\Window_%COMPUTERNAME%_raw\W-66.txt
type C:\Window_%COMPUTERNAME%_raw\W-66.txt | find ",*S-1-5-32-544">> C:\Window_%COMPUTERNAME%_raw\W-66-1.txt
type C:\Window_%COMPUTERNAME%_raw\W-66.txt | find "*S-1-5-32-544,">> C:\Window_%COMPUTERNAME%_raw\W-66-1.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-66-1.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-66,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �ý��ۿ��� ������ �ý��� ���ᡱ ��å�� ��Administrators���� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �ý��ۿ��� ������ �ý��� ���ᡱ ��å�� ��Administrators���� ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeRemoteShutdownPrivilege" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �ý��ۿ��� ������ �ý��� ���ᡱ ��å�� ��Administrators���� �����ϹǷ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-66,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �ý��ۿ��� ������ �ý��� ���ᡱ ��å�� ��Administrators���� �����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �ý��ۿ��� ������ �ý��� ���ᡱ ��å�� ��Administrators�� �Ǵ� �ٸ� ������ ������ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeRemoteShutdownPrivilege" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ �ý��ۿ��� ������ �ý��� ���ᡱ ��å�� ��Administrators�� �Ǵ� �ٸ� ������ �����ϹǷ� �����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-67------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "CrashOnAuditFail" | Findstr "0"
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-67,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å�� ����� �� �ԡ����� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å[CrashOnAuditFail]�� ����� �� �ԡ����� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "CrashOnAuditFail" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å�� ����� �� �ԡ����� �Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-67,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å�� ����� �� �ԡ����� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å[CrashOnAuditFail]�� ����롱���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "CrashOnAuditFail" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ���縦 �α��� �� ���� ��� ��� �ý��� ���ᡱ ��å�� ����롱���� �Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-68------------------------------------------
reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "restrictanonymous" | FINDSTR /V /I "SAM" | findstr "1" 
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "RestrictAnonymousSAM" | findstr "1" 
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-68,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ��� ��SAM ������ �͸� ���� ��� �� �ԡ��� ����롱���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ�[restrictanonymous]�� ��SAM ������ �͸� ���� ��� �� �ԡ�[restrictanonymoussam]�� ����롱[1]���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "restrictanonymous" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ��� ��SAM ������ �͸� ���� ��� �� �ԡ��� ����롱���� �Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ
		echo W-68,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ��� ��SAM ������ �͸� ���� ��� �� �ԡ��� ����롱���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ�[restrictanonymous]�� ����롱[1]���� ��SAM ������ �͸� ���� ��� �� �ԡ�[restrictanonymoussam]�� ����� �� �ԡ�[0]���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "restrictanonymous" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ��� ����롱���� ��SAM ������ �͸� ���� ��� �� �ԡ��� ����� �� �ԡ����� �Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	echo W-68,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ��� ��SAM ������ �͸� ���� ��� �� �ԡ��� ����롱���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ�[restrictanonymous]�� ����� �� �ԡ�[0]���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "restrictanonymous" | FINDSTR /V /I "SAM" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ��SAM ������ ������ �͸� ���� ��� �� �ԡ��� ����� �� �ԡ����� �Ǿ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-69------------------------------------------
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "AutoAdminLogon" | findstr "1"
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-69,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo AutoAdminLogon ���� ���ų� 0���� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo AutoAdminLogon ���� ���ų� 0���� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "AutoAdminLogon" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO AutoAdminLogon ���� ���ų� 0���� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-69,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo AutoAdminLogon ���� ���ų� 0���� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo AutoAdminLogon ���� ���ų� 0���� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "AutoAdminLogon" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������� ������ ���� ��� ���� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO AutoAdminLogon ���� ���ų� 0���� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-70------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AllocateDASD" | Findstr "0"
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-70,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̵��� �̵�� ���� �� ������ ��롱 ��å�� ��Administrator���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̵��� �̵�� ���� �� ������ ��롱 ��å[AllocateDASD]�� ��Administrator���� �Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AllocateDASD" | Findstr "0" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̵��� �̵�� ���� �� ������ ��롱 ��å�� ��Administrator���� �Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-70,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̵��� �̵�� ���� �� ������ ��롱 ��å�� ��Administrator���� �Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̵��� �̵�� ���� �� ������ ��롱 ��å[AllocateDASD]�� �Ǿ����� �ʰų� ��Administrator���� �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AllocateDASD" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������� ���� ��� ��� ������ �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���̵��� �̵�� ���� �� ������ ��롱 ��å ������ �Ǿ����� �ʰų� ��Administrator���� �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-71------------------------------------------
echo W-71,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo "������ ��ȣ�� ���� ������ ��ȣȭ "��å�� ���õ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo Windows Server 2012�� �ش� �׸� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo Windows Server 2012�� �ش� �׸� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-72------------------------------------------
echo W-72,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo DOS ��� ������Ʈ�� ���� �Ʒ��� ���� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo Windows Server 2012�� �ش� �׸� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo Windows Server 2012�� �ش� �׸� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-73------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AddPrinterDrivers" | FINDSTR "1"
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-73,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ڰ� ������ ����̹��� ��ġ�� �� ���� �ԡ� ��å�� ����롱�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ڰ� ������ ����̹��� ��ġ�� �� ���� �ԡ� ��å[AddPrinterDrivers]�� ����롱���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AddPrinterDrivers" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ڰ� ������ ����̹��� ��ġ�� �� ���� �ԡ� ��å�� ����롱���� �����Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-73,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ڰ� ������ ����̹��� ��ġ�� �� ���� �ԡ� ��å�� ����롱�� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ڰ� ������ ����̹��� ��ġ�� �� ���� �ԡ� ��å[AddPrinterDrivers]�� ����� �� �ԡ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AddPrinterDrivers" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ڰ� ������ ����̹��� ��ġ�� �� ���� �ԡ� ��å�� ����� �� �ԡ����� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-74------------------------------------------
reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" | find /I "EnableForcedLogOff" | FINDSTR /I "0x1"
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters"| find /I "AutoDisconnect" | FINDSTR /I "0xf"
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-74,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å�� ��15�С����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å[EnableForcedLogOff]�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å[AutoDisconnect]�� ��15�С����� ���� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters"| find /I "AutoDisconnect" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" | find /I "EnableForcedLogOff" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å�� ��15�С����� ���� �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ
		echo W-74,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å�� ��15�С����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å[EnableForcedLogOff]�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å[AutoDisconnect]�� ��15�С����� ���� �Ǿ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters"| find /I "AutoDisconnect" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" | find /I "EnableForcedLogOff" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å�� ��15�С����� ���� �Ǿ����� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ
	echo W-74,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����롱����, ������ ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð��� ��å�� ��15�С����� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����� �� �ԡ����� ���� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" | find /I "EnableForcedLogOff" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ���α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ���⡱ ��å�� ����� �� �ԡ����� ���� �Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-75------------------------------------------
FOR /F "tokens=3" %%k IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ^| FIND /I "LegalNoticeCaption"') DO echo %%k >> C:\Window_%COMPUTERNAME%_raw\W-75.txt
FOR /F "tokens=3" %%j IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" ^| FIND /I "LegalNoticeText"') DO echo %%j >> C:\Window_%COMPUTERNAME%_raw\W-75.txt
FOR /F "tokens=3" %%y IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" ^| FIND /I "legalnoticecaption"') DO echo %%y >> C:\Window_%COMPUTERNAME%_raw\W-75.txt
FOR /F "tokens=3" %%b IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" ^| FIND /I "legalnoticetext"') DO echo %%b >> C:\Window_%COMPUTERNAME%_raw\W-75.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-75.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-75,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α��� ��� �޽������� �� ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α��� ��� �޽������� �� ������ �����Ǿ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Winlogon_LegalNotice ���� ��� �޽��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "LegalNoticeCaption" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "LegalNoticeText" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo system_LegalNotice ���� ��� �޽��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | FIND /I "legalnoticecaption" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | FIND /I "legalnoticetext" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α��� ��� �޽������� �� ������ �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-75,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α��� ��� �޽������� �� ������ �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α��� ��� �޽������� �� ������ �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Winlogon_LegalNotice ���� ��� �޽��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "LegalNoticeCaption" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "LegalNoticeText" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo system_LegalNotice ���� ��� �޽��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | FIND /I "legalnoticecaption" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | FIND /I "legalnoticetext" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �α��� ��� �޽������� �� ������ �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-76------------------------------------------
dir "C:\Users\*" | find "<DIR>" | findstr /V "All Defalt ." >> C:\Window_%COMPUTERNAME%_raw\home-directory.txt
FOR /F "tokens=5" %%i IN (C:\Window_%COMPUTERNAME%_raw\home-directory.txt) DO cacls "C:\Users\%%i" >> C:\Window_%COMPUTERNAME%_raw\W-76.txt
type C:\Window_%COMPUTERNAME%_raw\W-76.txt  | find /I "Everyone" >> C:\Window_%COMPUTERNAME%_raw\W-76-1.txt
ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-76-1.txt
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-76,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� Ȩ ���͸��� Everyone ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� Ȩ ���͸��� Everyone ������ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� Ȩ ���͸��� Everyone ������ �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-76,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� Ȩ ���͸��� Everyone ������ ���� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� Ȩ ���͸��� Everyone ������ ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	TYPE C:\Window_%COMPUTERNAME%_raw\W-76.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ����� Ȩ ���͸��� Everyone ������ �����ϹǷ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-77------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" >> C:\Window_%COMPUTERNAME%_raw\W-77.txt
type C:\Window_%COMPUTERNAME%_raw\W-77.txt  | find /I "3"
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-77,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  LM NTML ���� ���� LmCompatibilityLevel=4,0 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  LM NTML NTLMv2���� ���� ��� LmCompatibilityLevel=4,1 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLM ���� ���� LmCompatibilityLevel=4,2 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLMv2 ���丸 ���� LmCompatibilityLevel=4,3 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLMv2 ���丸 ����WLM�ź� LmCompatibilityLevel=4,4 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLMv2 ���丸 ����WLM�ź� NTLM �ź� LmCompatibilityLevel=4,5 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  ���� �ش� ������ �����ϸ� Ŭ���̾�Ʈ�� ���� �Ǵ� ���� ���α׷����� ȣȯ���� ������ ��ĥ �� ����.  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ
	echo W-77,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  LM NTML ���� ���� LmCompatibilityLevel=4,0 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  LM NTML NTLMv2���� ���� ��� LmCompatibilityLevel=4,1 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLM ���� ���� LmCompatibilityLevel=4,2 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLMv2 ���丸 ���� LmCompatibilityLevel=4,3 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLMv2 ���丸 ����WLM�ź� LmCompatibilityLevel=4,4 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  NTLMv2 ���丸 ����WLM�ź� NTLM �ź� LmCompatibilityLevel=4,5 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo  ���� �ش� ������ �����ϸ� Ŭ���̾�Ʈ�� ���� �Ǵ� ���� ���α׷����� ȣȯ���� ������ ��ĥ �� ����.  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LmCompatibilityLevel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo - ���� ������ ���� ��� "LAN Manager ���� ����" ��å�� ���ǵ��� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-78------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal" | find "1" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "SealSecureChannel" | find "1" >nul
	IF NOT ERRORLEVEL 1 (
		REM ���
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "SignSecureChannel" | find "1" >nul
		IF NOT ERRORLEVEL 1 (
			REM ���
			echo W-78,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO �Ʒ� 3���� ��å�� "���"���� ���� �Ǿ��ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ������ ������: ���� ä��: �����͸� ������ ��ȣȭ �Ǵ�, ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ��ȣȭ ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO �� 3���� ��å�� "���"���� ���� �Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO �� 3���� ��å�� "���"���� ���� �Ǿ������Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		) ELSE (
			REM ��ȣ
			echo W-78,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO �Ʒ� 3���� ��å�� "���"���� ���� �Ǿ��ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ������ ������: ���� ä��: �����͸� ������ ��ȣȭ �Ǵ�, ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ��ȣȭ ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ������ ������: ���� ä��: ����ä�� �����͸� ������ ��ȣȭ ��å�� "��� �� ��"���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ������ ������: ���� ä��: ����ä�� �����͸� ������ ��ȣȭ ��å�� "��� �� ��"���� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
		REM ��ȣ
		echo W-78,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO �Ʒ� 3���� ��å�� "���"���� ���� �Ǿ��ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ������ ������: ���� ä��: �����͸� ������ ��ȣȭ �Ǵ�, ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ��ȣȭ ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ���� ��å�� "��� �� ��"���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ���� ��å�� "��� �� ��"���� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ
	echo W-78,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �Ʒ� 3���� ��å�� "���"���� ���� �Ǿ��ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ������: ���� ä��: �����͸� ������ ��ȣȭ �Ǵ�, ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ���� ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ������ ������: ���� ä��: ����ä�� �����͸� ������ ��ȣȭ ��å�� "���" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ������: ���� ä��: �����͸� ������ ��ȣȭ �Ǵ�, ���� ��å�� "��� �� ��"���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ������ ������: ���� ä��: �����͸� ������ ��ȣȭ �Ǵ�, ���� ��å�� "��� �� ��"���� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-79------------------------------------------
cacls c:\ | FIND /I "NT" > nul
IF NOT ERRORLEVEL 1 (
	echo W-79,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NTFS ���� �ý����� ����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NTFS ���� �ý����� ����ϰ� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	cacls c:\ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NTFS ���� �ý����� ����ϰ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt	
) ELSE (
	echo W-79,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NTFS ���� �ý����� ����ϴ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NTFS ���� �ý����� ����ϰ� ���� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	cacls c:\ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo NTFS ���� �ý����� ����ϰ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-80------------------------------------------
FOR /F "tokens=3" %%Y in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| Findstr /I "MaximumPasswordAge"') DO set MaximumPasswordAge1=%%Y
IF "%MaximumPasswordAge1%" LSS "90" (
	REM ���
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "disablepasswordchange" | FIND "0"
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-80,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å�� "90��"�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å[disablepasswordchange]�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å[MaximumPasswordAge]�� "90��"�� �����Ǿ� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "\MaximumPasswordAge disablepasswordchange" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å�� "90��"�� �����Ǿ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ 
		echo W-80,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å�� "90��"�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å[disablepasswordchange]�� "���"���� �����Ǿ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "\MaximumPasswordAge disablepasswordchange" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å�� "���"���� �����Ǿ������Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ 
	echo W-80,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å�� "90��"�� �����Ǿ� �ִ� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å[disablepasswordchange]�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å[MaximumPasswordAge]�� "90��"�� �����Ǿ� ���� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "\MaximumPasswordAge disablepasswordchange" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo "��ǻ�� ���� ��ȣ ���� ��� �� ��" ��å�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ" ��å�� "90��"�� �����Ǿ� ���� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-81------------------------------------------
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_raw\W-81.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_raw\W-81.txt
TYPE C:\Window_%COMPUTERNAME%_raw\W-81.txt | FINDSTR /I "\" >nul
IF NOT ERRORLEVEL 1 (
	REM ���
	echo W-81,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �������α׷� ����� ���������� �˻��ϰ� ���ʿ��� ���� üũ������ �� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO �������α׷� ����� Ȯ�� �� ���ʿ��� ���� �� ���α׷� ����� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �������α׷� ����� ���������� �˻��ϰ� ���ͺ並 ���� ���ʿ��� ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
	REM ��ȣ 
	echo W-81,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �������α׷� ����� ���������� �˻��ϰ� ���ʿ��� ���� üũ������ �� ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	ECHO ���� ���α׷� ����� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �������α׷� ����� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------W-82------------------------------------------
net start | find "SQL Server" > nul
IF NOT ERRORLEVEL 1 (
	REM ���
	reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server" /s | find /I "LoginMode" | findstr /I "1" > nul
	IF NOT ERRORLEVEL 1 (
		REM ���
		echo W-82,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Windows ���� ��带 ����ϰ� sa������ ��Ȱ��ȭ�Ǿ� �ְų� sa���� ��� �� ������ ��ȣ��å�� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo LoginMode 1 �̸� Windows ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo LoginMode 2 �̸� SQL Server �� Windows ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server" /s | find /I "LoginMode"  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Windows ���� ��带 ����ϰ� �����Ƿ� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		REM ��ȣ 
		echo W-82,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo Windows ���� ��带 ����ϰ� sa������ ��Ȱ��ȭ�Ǿ� �ְų� sa���� ��� �� ������ ��ȣ��å�� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo LoginMode 1 �̸� Windows ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo LoginMode 2 �̸� SQL Server �� Windows ���� ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Microsoft SQL Server" /s | find /I "LoginMode"  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ȥ�� ���� ��带 ����ϰ� �����Ƿ� ����� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	REM ��ȣ 
	echo W-82,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo Windows ���� ��带 ����ϰ� sa������ ��Ȱ��ȭ�Ǿ� �ְų� sa���� ��� �� ������ ��ȣ��å�� ������ ��� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ��Ȳ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SQL Server ������� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo �� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SQL Server ����ϰ� ���� �����Ƿ� �ش� �׸� ��ȣ�� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo.
echo.
echo.
echo.
echo         --------------------------------------------------------------------
echo         --                                                                --
echo         --                                                                --
echo         --                 SECURITY CHECK FINISH	                       --
echo         --                                                                --
echo         --                                                                --
echo         --------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo --------------------------------------rawdata---------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-01------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr "NewAdministratorName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-02------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net user guest | find "Account active">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-03------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net user | find /V "successfully">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-04------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net accounts | find "Lockout threshold">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-05------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ClearTextPassword">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-06------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup Administrators | findstr /V "Comment Members completed">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-07------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "EveryoneIncludesAnonymou">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-08------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "ResetLockoutCount">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LockoutDuration">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-09------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "PasswordComplexity">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-10------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordLength">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-11------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MaximumPasswordAge">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-12------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "MinimumPasswordAge">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-13------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-14------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-15------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LSAAnonymousNameLookup">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-16------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "PasswordHistorySize">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-17------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LimitBlankPasswordUse">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-18------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup "Administrators" | findstr /V "Comment Members completed" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-19------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-19.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-19-1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-20------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net share | FIND /V "IPC$" | FIND /V "ADMIN" | FIND /V "command PRINT$ FAX$" | FIND "$" | findstr /I "^[A-Z]">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-21------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start | findstr "Alerter ClipBook Messenger">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start | find "Simple TCP/IP Services">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-22------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start | find "World Wide Web Publishing Service">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-23------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-23.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-24------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls C:\inetpub\scripts >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls C:\inetpub\cgi-bin >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-25------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find "enableParentPaths">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-26------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
type C:\Window_%COMPUTERNAME%_raw\W-26.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-27------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
reg query "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC" | FINDSTR /L "ObjectName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\IISADMIN" | FINDSTR /L "ObjectName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------localgroup Administrators---------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup Administrators>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-28------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
TYPE C:\Window_%COMPUTERNAME%_raw\W-28.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-29------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find /I "bufferingLimit">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find /I "maxRequestEntityAllowed">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-30------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find ".asa" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config | find ".asax">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-31------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo �ش� ����� IIS 6.0 �̻��̹Ƿ� �ش� �׸� ��ȣ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt    
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-32------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
type C:\Window_%COMPUTERNAME%_raw\W-32.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-33------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-33.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-34------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
ECHO Windows server 2008�̻� ������ ��ȣ �׷��Ƿ� Windows 2012�� ��ȣ>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-35------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters" /s>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-36------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
REG QUERY HKLM\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces /S>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-37------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
NET START | FINDSTR /L "FTP">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-38------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\w-38-1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-39------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
TYPE C:\Window_%COMPUTERNAME%_raw\ftp_config.txt | find /i "anonymousAuthentication" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-40------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\w-40-1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-41------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\w-41.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-42------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
ECHO Windows server 2008�̻� ������ ��ȣ �׷��Ƿ� Windows 2012�� ��ȣ>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-43------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
type C:\Window_%COMPUTERNAME%_raw\systeminfo.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-44------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-45------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "<error" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-46------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-47------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-48------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-49------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | findstr "AllowUpdate">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-50------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
echo ������ 2000�� �ش�� ����� ���� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-51------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt 
reg query "HKLM\Software\Microsoft\TelnetServer\1.0" | FIND "SecurityMechanism">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-52------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-53------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /S  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-54------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
at>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-55------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\systeminfo.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-56------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-56.txt  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-57------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditLogonEvents" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditPrivilegeUse" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditPolicyChange" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditDSAccess" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditAccountLogon" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AuditAccountManage" >> C:\Window_%COMPUTERNAME%_raw\W-57.txt
type C:\Window_%COMPUTERNAME%_raw\W-57.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-58------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo �α� ��� ���� �� �м��� �����Ͽ� ����Ʈ�� �ۼ��ϰ� ���������� �����ϴ��� ���ͺ並 ���� Ȯ�� �ʿ� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-59------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start | find "Remote Registry">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-60------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------Security------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security" | find /I "MaxSize">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Security" | find /I "Retention">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------System------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System" | find /I "MaxSize">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\System" | find /I "Retention">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------Application------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application" | find /I "MaxSize">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog\Application" | find /I "Retention">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-61------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls %systemroot%\system32\logfiles >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls %systemroot%\system32\config >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-62------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-62.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-63------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls %windir%\system32\config\SAM >> C:\Window_%COMPUTERNAME%_raw\W-63-1.txt
cacls %systemroot%\system32\config\SAM >> C:\Window_%COMPUTERNAME%_raw\W-63-1.txt
type C:\Window_%COMPUTERNAME%_raw\W-63-1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-64------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveTimeOut">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-65------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find /I "ShutdownWithoutLogon" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-66------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeRemoteShutdownPrivilege" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-67------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "CrashOnAuditFail">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-68------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "restrictanonymous" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\LSA" | find /I "RestrictAnonymousSAM" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-69------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "AutoAdminLogon" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-70------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AllocateDASD" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-71------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
ECHO Windows server 2008�̻� ������ ��ȣ �׷��Ƿ� Windows 2012�� ��ȣ>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt  
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-72------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "SynAttackProtect" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "EnableDeadGWDetect" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "KeepAliveTime" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | find /I "NoNameReleaseOnDemand" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo �����Ǿ����� ���� ���, ���>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-73------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "AddPrinterDrivers" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-74------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters"| find /I "AutoDisconnect">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" | find /I "EnableForcedLogOff">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-75------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------Winlogon--------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "LegalNoticeCaption" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | FIND /I "LegalNoticeText" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------system----------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | FIND /I "legalnoticecaption" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | FIND /I "legalnoticetext" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo �α��� ��� �޽������� �� ������ �����Ǿ� ���� ���� ���, ��� >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-76------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\W-76.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-77------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "LmCompatibilityLevel">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-78------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "RequireSignOrSeal SealSecureChannel SignSecureChannel">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-79------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls c:\ >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-80------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Findstr /I "\MaximumPasswordAge disablepasswordchange" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-81------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------W-82------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server" /s >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------ipconfig------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
ipconfig /all >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------ver------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
ver >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------netstat------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
netstat -an | find /v "TIME_WAIT">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------net------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start | find /v "started" | find /v "completed">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------set------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
set >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------COMPUTER------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------web_config------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\IIS_WEB_CONFIG.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ������� ������ ���� ��� iis �̼�ġ �� �⺻����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------web services informaion------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >>C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ������� ������ ���� ��� web services �̼�ġ �� �⺻����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------iis informaion------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\inetStp" /s>>C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ������� ������ ���� ��� iis �̼�ġ �� �⺻����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------FTP informaion------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\ftp_config.txt >>C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ������� ������ ���� ��� FTP �̼�ġ �� �⺻����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------Windows update------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /s >>C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ������ ������Ʈ ���� ����>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------net start------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------sc query------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------IIS FTP------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------Windows update------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
date /t >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
time /t >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo --------------------------------------SRV-004 ���ʿ��� SMTP ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-039 ���ʿ��� Tmax WebtoB ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
tasklist >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net start >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-063 DNS Recursive Query ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DNS\Parameters" | findstr -I norecursion >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-113 ���� ��Ͽ� ���� ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
powershell "Get-ACL HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Security | FL" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-124 �α׿� ĳ�� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | findstr -I CachedLogonsCount >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-138 �Ϲ� ������� ��� �� ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup "backup operators" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup "users" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-139 �Ϲ� ������� �ý��� �ڿ� ������ ���� ���� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls "%systemroot%" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls "%programfiles%" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
cacls "%comspec%" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt

echo --------------------------------------SRV-141 ��ȭ�� ��� �̿� ����------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" | findstr /i "enablefirewall" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt


cd c:\
rd /S /Q C:\Window_%COMPUTERNAME%_raw
start C:\Window_%COMPUTERNAME%_result\
