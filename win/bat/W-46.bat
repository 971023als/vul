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
echo ------------------------------------------설정 시작---------------------------------------
...
echo ------------------------------------------IIS 설정-----------------------------------
...
echo ------------------------------------------end-------------------------------------------
echo ------------------------------------------W-46 SNMP 서비스 상태 검사------------------------------------------
net start | findstr /I "SNMP" >nul
IF NOT ERRORLEVEL 1 (
    echo W-46,경고,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo SNMP 서비스가 활성화되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 이는 보안상 위험할 수 있으므로, 필요하지 않은 경우 비활성화하는 것이 권장됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
    echo W-46,OK,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo SNMP 서비스가 실행되지 않고 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 이는 추가 보안을 위한 긍정적인 상태입니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------end------------------------------------------
echo ------------------------------------------결과 요약------------------------------------------
:: 결과 요약 보고
type C:\Window_%COMPUTERNAME%_result\W-Window-* >> C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt

:: 이메일로 결과 요약 보내기 (가상의 명령어, 실제 환경에 맞게 수정 필요)
:: sendmail -to admin@example.com -subject "Security Audit Summary" -body C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt

echo 결과가 C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt에 저장되었습니다.

:: 정리 작업
echo 정리 작업을 수행합니다...
del C:\Window_%COMPUTERNAME%_raw\*.txt
del C:\Window_%COMPUTERNAME%_raw\*.vbs

echo 스크립트를 종료합니다.
exit
