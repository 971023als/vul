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
echo ------------------------------------------설정---------------------------------------
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
echo ------------------------------------------끝-------------------------------------------

echo ------------------------------------------W-03------------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\
net user | find /v "성공적으로" | find /v "사용자" >> user.txt 
FOR /F "tokens=1" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%j | find "계정 활성 상태" | findstr "Yes" >nul 
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        net user %%j | find "사용자 이름" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        net user %%j | find "계정 활성 상태" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
    ) ELSE (
        ECHO.
    )
)
ECHO.
FOR /F "tokens=2" %%y IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%y | find "계정 활성 상태" | findstr "Yes" >nul 
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        net user %%y | find "사용자 이름" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        net user %%y | find "계정 활성 상태" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
    ) ELSE (
        ECHO.
    )
)
ECHO.
FOR /F "tokens=3" %%b IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%b | find "계정 활성 상태" | findstr "Yes" >nul 
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        net user %%b | find "사용자 이름" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        net user %%b | find "계정 활성 상태" >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_info.txt 
    ) ELSE (
        ECHO.
    )
)
ECHO.
cd "%install_path%"
type C:\Window_%COMPUTERNAME%_raw\user_info.txt | findstr /I "test guest" >nul 
IF NOT ERRORLEVEL 1 (
    echo W-03,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 위반 사항이 감지되었습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 시스템에 활성화되어서는 안 되는 사용자 계정이 존재합니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 권장 조치 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo test 및 Guest라는 이름의 사용자 계정을 비활성화하거나 제거하십시오 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\user_info.txt>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 추가 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo test 계정은 특히 중요하며 즉시 조치를 취해야 합니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
    echo W-03,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 위반 사항이 없습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 시스템에 금지된 사용자 계정이 존재하지 않습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 조치가 필요 없습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\user_info.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 추가 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 규정 준수를 보장하기 위해 정기적으로 사용자 계정을 검토하고 모니터링하십시오 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------끝------------------------------------------

echo --------------------------------------W-03------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net user | find /V "성공적으로">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
