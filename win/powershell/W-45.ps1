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
echo ------------------------------------------W-45 IIS 커스텀 에러 페이지 설정 검사------------------------------------------
net start | find "World Wide Web Publishing Service" >nul
IF NOT ERRORLEVEL 1 (
	FOR /F "tokens=1 delims=#" %%a in ('type C:\Window_%COMPUTERNAME%_raw\http_path.txt') DO (
		cd %%a
		type web.config >> C:\Window_%COMPUTERNAME%_raw\W-45.txt
	)
	type C:\Window_%COMPUTERNAME%_raw\W-45.txt | find /I "error statusCode" >> C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt
	IF NOT ERRORLEVEL 1 (
		type C:\Window_%COMPUTERNAME%_raw\iis_setting.txt | find /I "%SystemDrive%\inetpub\custerr\" >> C:\Window_%COMPUTERNAME%_raw\W-45-RAW2.txt
		ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\W-45-RAW2.txt
		IF NOT ERRORLEVEL 1 (
			echo W-45,경고,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 커스텀 에러 페이지 설정이 적절하지 않아 보안에 취약할 수 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-45-RAW1.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			type C:\Window_%COMPUTERNAME%_raw\W-45-RAW2.txt >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt			
		) ELSE (
			echo W-45,OK,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
			echo 커스텀 에러 페이지 설정이 적절하게 구성되어 보안이 강화되었습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		)
	) ELSE (
		echo W-45,정보,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 커스텀 에러 페이지 설정이 발견되지 않았습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	echo W-45,정보,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo World Wide Web Publishing Service가 실행되지 않고 있습니다. IIS 설정이 필요 없을 수 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
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
