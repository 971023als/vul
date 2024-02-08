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
echo ------------------------------------------설정 시작---------------------------------------
...
echo ------------------------------------------IIS 설정-----------------------------------
...
echo ------------------------------------------end-------------------------------------------
echo ------------------------------------------W-48 SNMP 허용된 관리자 설정 검사------------------------------------------
net start | findstr /I "SNMP" >nul
IF NOT ERRORLEVEL 1 (
	reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers >> C:\Window_%COMPUTERNAME%_raw\W-48.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-48.txt
	IF NOT ERRORLEVEL 1 (
		echo W-48,OK,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SNMP 서비스가 실행 중이며 허용된 관리자가 구성되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 해당 설정은 네트워크 보안을 강화하는 데 도움이 됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		echo W-48,경고,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SNMP 서비스가 실행 중이지만 허용된 관리자가 명확하게 구성되지 않았습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo SNMP 관리를 위한 보안 조치로 허용된 관리자를 명확하게 설정하는 것이 권장됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	echo W-48,정보,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo SNMP 서비스가 실행되지 않고 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------결과 요약------------------------------------------
...
echo 스크립트를 종료합니다.
exit
