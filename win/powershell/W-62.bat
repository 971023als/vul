@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%getadmin.vbs"
    "%getadmin.vbs"
	del "%getadmin.vbs"
    exit /B

:gotAdmin
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------설정------------------------------------------
rd /S /Q "C:\Window_%COMPUTERNAME%_raw"
rd /S /Q "C:\Window_%COMPUTERNAME%_result"
mkdir "C:\Window_%COMPUTERNAME%_raw"
mkdir "C:\Window_%COMPUTERNAME%_result"
del "C:\Window_%COMPUTERNAME%_result\W-Window-*.txt"
secedit /EXPORT /CFG "C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt"
fsutil file createnew "C:\Window_%COMPUTERNAME%_raw\compare.txt"  0
cd >> "C:\Window_%COMPUTERNAME%_raw\install_path.txt"
for /f "tokens=2 delims=:" %%y in ('type "C:\Window_%COMPUTERNAME%_raw\install_path.txt"') do set install_path=c:%%y 
systeminfo >> "C:\Window_%COMPUTERNAME%_raw\systeminfo.txt"
echo ------------------------------------------IIS 설정---------------------------------------
type "%WinDir%\System32\Inetsrv\Config\applicationHost.Config" >> "C:\Window_%COMPUTERNAME%_raw\iis_setting.txt"
type "C:\Window_%COMPUTERNAME%_raw\iis_setting.txt" | findstr "physicalPath bindingInformation" >> "C:\Window_%COMPUTERNAME%_raw\iis_path1.txt"
set "line="
for /F "delims=" %%a in ('type "C:\Window_%COMPUTERNAME%_raw\iis_path1.txt"') do (
set "line=!line!%%a" 
)
echo !line! >> "C:\Window_%COMPUTERNAME%_raw\line.txt"
for /F "tokens=1-5 delims=*" %%a in ('type "C:\Window_%COMPUTERNAME%_raw\line.txt"') do (
    echo %%a >> "C:\Window_%COMPUTERNAME%_raw\path1.txt"
    echo %%b >> "C:\Window_%COMPUTERNAME%_raw\path2.txt"
    echo %%c >> "C:\Window_%COMPUTERNAME%_raw\path3.txt"
    echo %%d >> "C:\Window_%COMPUTERNAME%_raw\path4.txt"
    echo %%e >> "C:\Window_%COMPUTERNAME%_raw\path5.txt"
)
type "C:\WINDOWS\system32\inetsrv\MetaBase.xml" >> "C:\Window_%COMPUTERNAME%_raw\iis_setting.txt"
echo ------------------------------------------종료-------------------------------------------

echo ------------------------------------------W-62------------------------------------------
reg query "HKLM\SOFTWARE\ESTsoft" /S >> "C:\Window_%COMPUTERNAME%_raw\W-62.txt"
reg query "HKLM\SOFTWARE\AhnLab" /S >> "C:\Window_%COMPUTERNAME%_raw\W-62.txt"
TYPE "C:\Window_%COMPUTERNAME%_raw\W-62.txt" | Findstr /I "AhnLab ESTsoft" >nul
IF NOT ERRORLEVEL 1 (
    REM 취약
    echo W-62,O,^| >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 작업 시작 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo ESTsoft 또는 AhnLab 소프트웨어가 설치된 경우 취약 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 조치 방안 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo ESTsoft 또는 AhnLab 소프트웨어의 보안 업데이트 필요 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    TYPE "C:\Window_%COMPUTERNAME%_raw\W-62.txt" >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 작업 완료 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 보안 업데이트를 통해 취약성을 해결 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo ^| >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
) ELSE (
    REM 안전
    echo W-62,C,^| >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 작업 시작 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo ESTsoft 또는 AhnLab 소프트웨어가 설치되지 않은 경우 안전 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 조치 방안 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 추가 조치 필요 없음 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo 작업 완료 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo ESTsoft 또는 AhnLab 소프트웨어가 설치되지 않아 안전합니다 >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
    echo ^| >> "C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt"
)
echo -------------------------------------------종료-------------------------------------------

echo ------------------------------------------결과 요약------------------------------------------
:: 결과 요약 보고
type "C:\Window_%COMPUTERNAME%_result\W-Window-*" >> "C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt"

:: 이메일로 결과 요약 보내기 (가상의 명령어, 실제 환경에 맞게 수정 필요)
:: sendmail -to admin@example.com -subject "Security Audit Summary" -body "C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt"

echo 결과가 "C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt"에 저장되었습니다.

:: 정리 작업
echo 정리 작업을 수행합니다...
del "C:\Window_%COMPUTERNAME%_raw\*.txt"
del "C:\Window_%COMPUTERNAME%_raw\*.vbs"

echo 스크립트를 종료합니다.
exit
