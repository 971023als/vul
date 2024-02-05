@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한 요청 중...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "getadmin.vbs"
    "getadmin.vbs"
    del "getadmin.vbs"
    exit /B

:gotAdmin
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------설정 초기화---------------------------------------
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
echo ------------------------------------------IIS 설정 분석-----------------------------------
type %WinDir%\System32\Inetsrv\Config\applicationHost.Config >> C:\Window_%COMPUTERNAME%_raw\iis_setting.txt
type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | findstr "physicalPath bindingInformation" >> C:\Window_%COMPUTERNAME%_raw\iis_path1.txt
echo ------------------------------------------IIS 설정 분석 완료-------------------------------------------

echo ------------------------------------------W-13 보안 정책 분석------------------------------------------
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName" | findstr "1" > nul
IF NOT ERRORLEVEL 1 (
    echo W-13,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 준수: 마지막으로 로그온한 사용자 이름을 표시하지 않는 정책이 활성화되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
    echo W-13,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 미준수: 마지막으로 로그온한 사용자 이름을 표시하지 않는 정책이 비활성화되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------보안 정책 분석 완료------------------------------------------

echo --------------------------------------W-13 데이터 캡처-------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "DontDisplayLastUserName">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
