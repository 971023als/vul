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
echo ------------------------------------------W-41 DNS 보안 설정 점검 시작------------------------------------------
net start | find /I "DNS Server" >nul
IF NOT ERRORLEVEL 1 (
	reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" /s | find "SecureSecondaries" | find "0x2"  >> C:\Window_%COMPUTERNAME%_raw\w-41.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\w-41.txt
	IF NOT ERRORLEVEL 1 (
		echo W-41,경고,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 상태 확인: 취약 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS 전송 설정이 취약한 구성으로 되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 조치 방안: DNS 전송 설정을 보안 강화를 위해 수정해야 합니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		echo W-41,안전,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 상태 확인: 안전 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo DNS 전송 설정이 안전하게 구성되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	echo W-41,정보,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 상태 확인: DNS 서비스 미설치 또는 비활성화 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo DNS 서비스가 실행 중이지 않습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------W-41 DNS 보안 설정 점검 종료------------------------------------------
...
echo 결과가 C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt에 저장되었습니다.
...
echo 정리 작업을 수행합니다...
del C:\Window_%COMPUTERNAME%_raw\*.txt
del C:\Window_%COMPUTERNAME%_raw\*.vbs

echo 스크립트를 종료합니다.
exit
