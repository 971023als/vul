@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한 요청 중...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject("Shell.Application") > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
chcp 437
color 02
setlocal enabledelayedexpansion
echo ------------------------------------------ 설정 ---------------------------------------
rd /S /Q C:\Windows_Security_Audit\%COMPUTERNAME%_raw
rd /S /Q C:\Windows_Security_Audit\%COMPUTERNAME%_result
mkdir C:\Windows_Security_Audit\%COMPUTERNAME%_raw
mkdir C:\Windows_Security_Audit\%COMPUTERNAME%_result

echo ------------------------------------------ W-64 스크린 세이버 정책 확인 ------------------------------------------
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaveActive" | findstr /I "1" >> C:\Windows_Security_Audit\%COMPUTERNAME%_raw\W-64-1.txt
reg query "HKCU\Control Panel\Desktop" | find "ScreenSaverIsSecure" | findstr /I "1" >> C:\Windows_Security_Audit\%COMPUTERNAME%_raw\W-64-2.txt

for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\Desktop" ^| find "ScreenSaveTimeOut"') do set ScreenSaveTimeOut=%%a

:: 스크린 세이버 활성화 및 안전한 로그온 확인
type C:\Windows_Security_Audit\%COMPUTERNAME%_raw\W-64-1.txt | find "1" > nul
if NOT ERRORLEVEL 1 (
    type C:\Windows_Security_Audit\%COMPUTERNAME%_raw\W-64-2.txt | find "1" > nul
    if NOT ERRORLEVEL 1 (
        if "%ScreenSaveTimeOut%" LSS "601" (
            echo W-64,O,^|>> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
            echo 스크린 세이버 정책 설정이 취약합니다. >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
            echo - 스크린 세이버 활성화[ScreenSaveActive]: 1 >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
            echo - 안전한 로그온 요구[ScreenSaverIsSecure]: 1 >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
            echo - 설정된 대기 시간[ScreenSaveTimeOut]: %ScreenSaveTimeOut%초 >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        ) else (
            echo W-64,X,^|>> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
            echo 스크린 세이버 정책 설정이 안전합니다. >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        )
    ) else (
        echo W-64,X,^|>> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
        echo 안전한 로그온이 요구되지 않습니다. 취약할 수 있습니다. >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    )
) else (
    echo W-64,X,^|>> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
    echo 스크린 세이버가 비활성화되어 있습니다. 취약할 수 있습니다. >> C:\Windows_Security_Audit\%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)

echo 결과가 C:\Windows_Security_Audit\%COMPUTERNAME%_result 폴더에 저장되었습니다.
echo 스크립트를 종료합니다.
exit
