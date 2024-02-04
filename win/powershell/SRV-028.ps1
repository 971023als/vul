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
SRV-001 (Windows) SNMP Community 스트링 설정 미흡

【 상세설명 】
SNMP 서비스는 네트워크 관리 및 네트워크 장치의 동작을 감시/통할하는 SNMP 프로토콜을 기반으로 하는 서비스로, SNMP 통신 시 접근 허용 여부를 결정하기 위한 SNMP community string의 복잡도가 낮게 설정되었는지 점검

【 판단기준 】
- 양호 : SNMP Community String 초기 값(Public, Private)이 아니고, 아래의 복잡도를 만족 할 경우
- 취약 : SNMP Community String 초기 값(Public, Private)이거나, 복잡도를 만족하지 않을 경우

※ (복잡도) 기본값(public, private) 미사용, 영문자, 숫자가 포함 10자리 이상 또는 영문자, 숫자, 특수문자 포함 8자리 이상
※ SNMP v3의 경우 별도 인증 기능을 사용하고, 해당 비밀번호가 복잡도를 만족할 경우 "양호"로 판단

【 판단방법 】
  1. SNMP 서비스 의 SNMP Community String 이 복잡도를 만족하는지 확인
      ※ <registry_path> : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities
      ※ 레지스트리 값이 존재하지 않으면 SNMP 서비스가 실행 중이어도 서비스를 사용할 수 없으므로 "양호" 로 판단

  ■ Windows 2008, 2008 R2, 2012, 2012 R2, 2016, 2019, 2022
      ① 시작 > 실행 > services.msc > 서비스 > SNMP Service 속성 > "보안" 탭 >
      ② "받아들인 커뮤니티 이름"  "> SNMP community string" 항목
  또는
      cmd > reg query <registry_path>
          <SNMP_community_string>     REG_DWORD    0x4
  또는
      cmd > reg query <registry_path>
          ERROR: The system was unable to find the specified registry key or value.

  ※ "ValidCommunities" Key 의 Value 값
      - 이름 : 
      - 종류 : REG_DWORD
      - 데이터 : 1(없음), 2(알림), 4(읽기 전용) 8(읽기, 쓰기), 16(읽기, 만들기)

【 조치방법 】
  1. SNMP Community String 을 복잡도를 만족하는 값으로 설정
      ※ 유추하기 쉬운 문자열(기관명, 기기명 등) 사용 자제 → 일부 기관에서 수정 권고하는 기준
      ※ "쓰기" 권한이 필요한 경우가 아니면 "읽기 전용" 권한 부여
      ※ NMS, 모니터링 등 목적으로 SNMP 서비스를 사용하는 경우 SNMP Manager 와 Agent 에 같은 Community String 이 설정되어 있어야 인증 가능
  2. SNMP 서비스 재시작
echo -------------------------------------------end------------------------------------------

echo --------------------------------------SRV-004 불필요한 SMTP 서비스 실행 여부------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
sc query smtp >> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
echo ------------------------------------------------------------------------------->> C:\Window_%COMPUTERNAME%_result\W-Window-%COMPUTERNAME%-rawdata.txt
