@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한을 요청합니다...
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
echo ------------------------------------------W-40 점검 시작------------------------------------------
cd "C:\Window_%COMPUTERNAME%_raw\"
dir | find /I "ftp_path.txt" >nul
IF NOT ERRORLEVEL 1 (
	TYPE C:\WINDOWS\system32\inetsrv\MetaBase.xml | findstr /i "IIsFtpService IIsFtpVirtualDir IPSecurity=" | find /I "0102" >> C:\Window_%COMPUTERNAME%_raw\w-40-1.txt
	ECHO n | COMP C:\Window_%COMPUTERNAME%_raw\compare.txt C:\Window_%COMPUTERNAME%_raw\w-40-1.txt
	IF NOT ERRORLEVEL 1 (
		echo W-40,경고,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 상태 확인: 취약 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 특정 IP 주소에서만 FTP 접속이 허용되어야 하나, 현재 모든 IP에서 접속이 허용되어 있어 취약합니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 조치 방안: 필요한 IP 주소만 접속을 허용하도록 설정 변경이 필요합니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	) ELSE (
		echo W-40,OK,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 상태 확인: 안전 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
		echo 특정 IP 주소에서만 FTP 접속이 허용되어 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	)
) ELSE (
	echo W-40,정보,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo 상태 확인: FTP 서비스 미설치 또는 비활성화 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
	echo FTP 경로 파일을 찾을 수 없습니다. FTP 서비스가 설치되어 있지 않거나 비활성화되어 있을 수 있습니다. >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
)
echo -------------------------------------------W-40 점검 종료------------------------------------------
...
echo 결과가 C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt에 저장되었습니다.
...
echo 정리 작업을 수행합니다...
del C:\Window_%COMPUTERNAME%_raw\*.txt
del C:\Window_%COMPUTERNAME%_raw\*.vbs

echo 스크립트를 종료합니다.
exit
