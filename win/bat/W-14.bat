rem windows server script edit 2020
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
echo ------------------------------------------Setting---------------------------------------
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
echo ------------------------------------------IIS Setting-----------------------------------
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
echo ------------------------------------------end-------------------------------------------

echo ------------------------------------------W-14------------------------------------------
echo W-14,C,^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ■ 기준 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo 로컬 로그온 허용 정책에 Administrators, IUSR_만 존재하는 경우 양호 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ■ 현황 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo 로컬 로그온 허용 정책[SeInteractiveLogonRight]에 Administrators, IUSR_만 존재하는 경우 양호 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN-LOCAL-GROUP  >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\ADMINISTRATORS     S-1-5-32-544                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\USERS              S-1-5-32-545                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\GUESTS             S-1-5-32-546                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\ACCOUNT OPERATORS  S-1-5-32-548                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\SERVER OPERATORS   S-1-5-32-549                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\PRINT OPERATORS    S-1-5-32-550                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\BACKUP OPERATORS   S-1-5-32-551                                                >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo BUILTIN\REPLICATOR         S-1-5-32-552 												>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- 												>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight" >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo --------------------------------------- 												>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ■ 설명 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo 인터뷰를 통해 불필요한 계정이 존재하면 취약으로 판단예정 >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo ^|>> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-result.txt
echo -------------------------------------------end------------------------------------------


echo --------------------------------------W-14------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
type C:\Window_%COMPUTERNAME%_raw\Local_Security_Policy.txt | Find /I "SeInteractiveLogonRight">> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
