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
echo ------------------------------------------SRV-001------------------------------------------
SRV-023 (Windows) 원격 터미널 서비스의 암호화 수준 설정 미흡

【 상세설명 】
원격 터미널 서비스는 원격지에 있는 서버를 관리하기 위한 유용한 도구이지만 원격 터미널 서비스의 암호화 수준이 낮을 경우, 계정 탈취 위협이 증가하므로 해당 설정의 적절성을 점검

【 판단기준 】
- 양호 : 원격 터미널 서비스를 사용하지 않거나 사용 시 암호화 수준을 "클라이언트와 호환 가능(중간)" 이상으로 설정한 경우
- 취약 : 원격 터미널 서비스를 사용하고 암호화 수준을 "낮음" 으로 설정한 경우

【 판단방법 】
  1. 원격 터미널 서비스의 암호화 수준 설정 확인
      ※ <registry_path> : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
      ※ "암호화 수준" 설정 "클라이언트 호환 가능" 이상 확인
      ※ 레지스트리 값이 “0”, "1" 이면 "취약"

  ■ Windows 2008
      ① 시작 > 실행 > tsconfig.msc > 『RDP-Tcp」 선택 > RDP-Tcp 속성 > "일반" 탭
      ② "암호화 수준" 설정 확인("클라이언트 호환 가능" 이상 "양호")
  또는
      cmd > reg query "<registry_path>" /v MinEncryptionLevel
          HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
              MinEncryptionLevel    REG_DWORD    0x2

  ※ "RDP-Tcp" 클라이언트 연결 암호화 수준
      - 낮음("1") : 클라이언트에서 서버로 보내는 모든 데이터는 클라이언트가 지원하는 최대 키 강도를 기반으로 하는 암호화로 보호
      - 클라이언트 호환 가능("2") : 클라이언트와 서버 간에 받은 모든 데이터는 클라이언트가 지원하는 최대 키 강도를 기반으로 하는 암호화로 보호
      - 높음("3") : 클라이언트와 서버 간에 받은 모든 데이터는 서버의 최대 키 강도를 기반으로 하는 암호화로 보호 이 암호화 수준을 지원하지 않는 클라이언트는 연결할 수 없음 
      - FIS 규격("4") : 클라이언트에서 서버로 보내는 모든 데이터를 Federal Information Processing Standard 140-1 유효 암호화 방법을 사용하여 보호

  ■ Windows 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      ① 시작 > 실행 > gpedit.msc > 컴퓨터 구성 > 관리 템플릿 > Windows 구성 요소 > 터미널 서비스 > 원격 데스크톱 세션 호스트 > 보안
      ② 클라이언트 연결 암호화 수준 설정 > "사용" 설정 확인
      ③ "암호화 수준" 설정 확인
  또는
      cmd > reg query "<registry_path>" /v MinEncryptionLevel
          HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
              MinEncryptionLevel    REG_DWORD    0x2

  ※ "원격 데스크톱 세션 호스트" 클라이언트 연결 암호화 수준
      - 낮음("1") : 클라이언트에서 서버로 보내는 모든 데이터는 클라이언트가 지원하는 최대 키 강도를 기반으로 하는 암호화로 보호
      - 클라이언트 호환 가능("2") : 클라이언트와 서버 간에 받은 모든 데이터는 클라이언트가 지원하는 최대 키 강도를 기반으로 하는 암호화로 보호
      - 높음("3") : 클라이언트와 서버 간에 받은 모든 데이터는 서버의 최대 키 강도를 기반으로 하는 암호화로 보호 이 암호화 수준을 지원하지 않는 클라이언트는 연결할 수 없음 

【 조치방법 】
  1. 원격 터미널 서비스의 암호화 수준 "클라이언트 호환 가능" 이상 설정
 
  2024-01-13 : (조치과정 삭제)
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 불필요한 SMTP 서비스 실행 여부------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
