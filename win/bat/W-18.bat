@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한이 필요합니다...
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
... (이하 반복 및 분석 과정 생략) ...

echo ------------------------------------------W-18 사용자 그룹 분석------------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\
FOR /F "tokens=*" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
    net user %%j | find "Remote Desktop Users" >nul
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt
        net user %%j | find "User name" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt
        net user %%j | find "Remote Desktop Users" >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_Remote.txt
    )
)

cd "%install_path%"
type C:\Window_%COMPUTERNAME%_raw\user_Remote.txt | findstr /I "test Guest" > nul
IF NOT ERRORLEVEL 1 (
    echo W-18,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 무단 사용자가 'Remote Desktop Users' 그룹에 발견되었습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\user_Remote.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 무단 접근 권한 수정을 검토하고 조치하세요. >> C:\Window_%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
echo W-18,C,^|>> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 'Remote Desktop Users' 그룹에 무단 사용자가 없습니다. 준수 상태가 확인되었습니다. >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
type C:\Window%COMPUTERNAME%raw\user_Remote.txt >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
조치가 필요 없습니다. >> C:\Window%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------사용자 그룹 분석 종료------------------------------------------

echo --------------------------------------W-18 데이터 캡처-------------------------------------->> C:\Window_%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-rawdata.txt
net localgroup "Administrators" | findstr /V "Comment Members completed" >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-rawdata.txt
echo -------------------------------------------------------------------------------->> C:\Window%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
