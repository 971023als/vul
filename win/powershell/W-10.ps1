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
echo ------------------------------------------W-10------------------------------------------
ECHO ------------------------------------------사용자_암호---------------------------------------
cd C:\Window_%COMPUTERNAME%_raw\ 
FOR /F "tokens=1" %%j IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%j | find "계정 활성 상태" | findstr "예" >nul 
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        net user %%j | find "사용자 이름" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        net user %%j | find "마지막으로 암호 설정됨" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
    ) ELSE (
        ECHO.
    )
)
ECHO.
FOR /F "tokens=2" %%y IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%y | find "계정 활성 상태" | findstr "예" >nul 
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        net user %%y | find "사용자 이름" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        net user %%y | find "마지막으로 암호 설정됨" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
    ) ELSE (
        ECHO.
    )
)
ECHO.
FOR /F "tokens=3" %%b IN ('type C:\Window_%COMPUTERNAME%_raw\user.txt') DO (
net user %%b | find "계정 활성 상태" | findstr "예" >nul 
    IF NOT ERRORLEVEL 1 (
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        net user %%b | find "사용자 이름" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        net user %%b | find "마지막으로 암호 설정됨" >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
        echo ----------------------------------------------------  >> C:\Window_%COMPUTERNAME%_raw\user_pw.txt 
    ) ELSE (
        ECHO.
    )
)
ECHO.
cd "%install_path%"
ECHO ------------------------------------------사용자_암호---------------------------------------
FOR /F "tokens=3" %%Y in ('type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt ^| find "최대암호사용기간" ^| findstr -v "Parameters"') DO set MaximumPasswordAge=%%Y
IF "%MaximumPasswordAge%" LSS "91" (
    echo W-11,O,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 정책 준수 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 최대 암호 사용 기간이 90일 미만으로 설정되어 정책에 준수됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 정책 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | find "최대암호사용기간" | findstr -v "Parameters" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 다음 사용자의 마지막 암호 설정 날짜를 확인하십시오: >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\user_pw.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 분석 완료 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 시스템이 최대 암호 사용 기간 정책에 준수됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
) ELSE ( 
    echo W-11,X,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 정책 비준수 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 최대 암호 사용 기간이 90일 이상으로 설정되어 정책에 비준수됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 정책 세부 사항 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | find "최대암호사용기간" | findstr -v "Parameters" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 다음 사용자의 마지막 암호 설정 날짜를 확인하십시오: >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    type C:\Window_%COMPUTERNAME%_raw\user_pw.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 분석 완료 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 시스템이 최대 암호 사용 기간 정책에 비준수됩니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------끝------------------------------------------

echo --------------------------------------W-10------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "최소암호길이">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
