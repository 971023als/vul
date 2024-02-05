@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한 요청 중...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "getadmin.vbs"
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
    echo %%a >> C:\Window_%COMPUTERNAME%raw\path3.txt
)
for /F "tokens=4 delims=*" %%a in ('type C:\Window%COMPUTERNAME%raw\line.txt') do (
echo %%a >> C:\Window%COMPUTERNAME%raw\path4.txt
)
for /F "tokens=5 delims=*" %%a in ('type C:\Window%COMPUTERNAME%raw\line.txt') do (
echo %%a >> C:\Window%COMPUTERNAME%raw\path5.txt
)
type C:\WINDOWS\system32\inetsrv\MetaBase.xml >> C:\Window%COMPUTERNAME%raw\iis_setting.txt
echo ------------------------------------------끝-------------------------------------------
echo ------------------------------------------W-23------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
REM 디렉토리 브라우징 체크
IF NOT ERRORLEVEL 1 (
REM 디렉토리 브라우징 설정 확인
FOR /F "tokens=1 delims=#" %%a in ('type C:\Window%COMPUTERNAME%raw\http_path.txt') DO (
cd %%a
type web.config | find "directoryBrowse" | find "true" >> C:\Window%COMPUTERNAME%raw\W-23.txt
type web.config >> C:\Window%COMPUTERNAME%raw\IIS_WEB_CONFIG.txt
)
cd "%install_path%"
ECHO n | COMP C:\Window%COMPUTERNAME%raw\compare.txt C:\Window%COMPUTERNAME%raw\W-23.txt
REM 결과 평가
IF NOT ERRORLEVEL 1 (
REM 디렉토리 브라우징 비활성화됨 (안전)
echo W-23,O,^|>> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 안전한 상태 >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 디렉토리 브라우징이 비활성화되어 있어 시스템이 안전합니다. >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
REM 디렉토리 브라우징이 활성화될 수 있음 (불안전)
type C:\Window%COMPUTERNAME%raw\W-23.txt | find "directoryBrowse" > nul
IF NOT ERRORLEVEL 1 (
REM 디렉토리 브라우징 활성화됨 (불안전)
echo W-23,X,^|>> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 불안전한 상태 >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 디렉토리 브라우징이 활성화되어 있어 시스템이 불안전합니다. >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
TYPE C:\Window%COMPUTERNAME%raw\W-23.txt >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
REM 디렉토리 브라우징 설정을 찾을 수 없음 (안전으로 간주)
echo W-23,O,^|>> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 안전한 상태 >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 디렉토리 브라우징 설정을 찾을 수 없어 시스템이 안전하다고 간주됩니다. >> C:\Window%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
)
) ELSE (
REM World Wide Web Publishing Service 실행 중지됨 (안전으로 간주)
echo W-23,O,^|>> C:\Window_%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo 안전한 상태 >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-result.txt
echo World Wide Web Publishing Service가 실행되지 않아 시스템이 안전하다고 간주됩니다. >> C:\Window%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------끝------------------------------------------

echo --------------------------------------W-23------------------------------------->> C:\Window_%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window%COMPUTERNAME%raw\W-23.txt >> C:\Window%COMPUTERNAME%result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
