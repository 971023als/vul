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
echo ------------------------------------------W-04------------------------------------------
for /f "tokens=3" %%a in ('net accounts ^| find "잠금 임계값"') do set threshold=%%a
if "%threshold%" GTR "5" (
    echo W-04,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 준수하지 않음이 감지되었습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 계정 잠금 임계값이 5회 시도보다 많게 설정되어 있으며, 이는 준수되지 않습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 권장 조치 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 잠금 임계값을 5회 이하로 설정하는 것이 권장됩니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    net accounts | find "잠금 임계값" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 추가 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 현재 설정은 무단 액세스의 위험을 증가시킬 수 있습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE (
    net accounts | find "잠금 임계값" | findstr /I "없음" >nul
    if NOT ERRORLEVEL 1 (
        echo W-04,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 준수하지 않음이 감지되었습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 계정 잠금 임계값이 설정되지 않았습니다(없음), 이는 준수되지 않습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 권장 조치 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 잠금 임계값을 특정 시도 횟수로 설정해야 합니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        net accounts | find "잠금 임계값" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 추가 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 잠금 임계값을 설정하지 않으면 무단 액세스의 위험이 증가합니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    ) ELSE ( 
        echo W-04,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 준수됨이 감지되었습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 계정 잠금 임계값이 준수 범위 내에 설정되었습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 조치가 필요 없습니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        net accounts | find "잠금 임계값" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 추가 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 현재 설정은 안전하고 준수된 것으로 간주됩니다 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    )
)
echo -------------------------------------------끝------------------------------------------

echo --------------------------------------W-04------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
net accounts | find "잠금 임계값">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
