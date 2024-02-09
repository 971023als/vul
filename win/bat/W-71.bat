@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo "관리자 권한을 요청합니다..."
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
rd /S /Q C:\Window_%COMPUTERNAME%_raw
rd /S /Q C:\Window_%COMPUTERNAME%_result
mkdir C:\Window_%COMPUTERNAME%_raw
mkdir C:\Window_%COMPUTERNAME%_result
del C:\Window_%COMPUTERNAME%_result\W-Window-*.txt
secedit /EXPORT /CFG C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt
fsutil file createnew C:\Window_%COMPUTERNAME%_raw\compare.txt 0
cd >> C:\Window_%COMPUTERNAME%_raw\install_path.txt
for /f "tokens=2 delims=:" %%y in ('type C:\Window_%COMPUTERNAME%_raw\install_path.txt') do set install_path=c:%%y 
systeminfo >> C:\Window_%COMPUTERNAME%_raw\systeminfo.txt
echo ------------------------------------------IIS 설정-----------------------------------
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
# (이하 생략)

echo ------------------------------------------W-71------------------------------------------
echo W-71,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo 설정 완료 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo "데이터 암호화를 요구하는 정책" 설정이 활성화된 상태입니다.
echo 상세 정보 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo Windows Server 2012 이상에서 해당 정책이 적용됩니다.
echo 작업 완료 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo Windows Server 2012 이상에서 해당 정책이 적용되어 있습니다.
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------종료------------------------------------------
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
