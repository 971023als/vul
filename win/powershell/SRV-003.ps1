# 관리자 권한 확인 및 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir -ItemType Directory -Force
New-Item -Path $resultDir -ItemType Directory -Force

# 보안 정책 및 시스템 정보 수집
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Force
cd $rawDir
[System.IO.File]::WriteAllText("$rawDir\install_path.txt", (Get-Location).Path)
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 수집
if (Test-Path $env:WinDir\System32\Inetsrv\Config\applicationHost.Config) {
    Get-Content $env:WinDir\System32\Inetsrv\Config\applicationHost.Config | Out-File "$rawDir\iis_setting.txt"
    Get-Content "$rawDir\iis_setting.txt" | Select-String "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
    # 추가 로직이 필요한 경우 여기에 작성
}

# SNMP 및 SMTP 서비스 상태 점검
$snmpStatus = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers
if ($snmpStatus) {
    "SNMP 설정이 양호합니다. 특정 호스트로부터만 SNMP 패킷을 받아들입니다." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
} else {
    "SNMP 설정이 취약합니다. 모든 호스트로부터 SNMP 패킷을 받아들일 수 있습니다. 조치가 필요합니다." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
}

$smtpService = Get-Service smtp -ErrorAction SilentlyContinue
if ($smtpService -and $smtpService.Status -eq 'Running') {
    "SMTP 서비스가 실행 중입니다. 불필요한 경우, 서비스를 비활성화하는 것을 고려하세요." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
} else {
    "SMTP 서비스가 실행 중이지 않습니다." | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
}

# 결과 알림
Write-Host "결과를 $resultDir\W-Window-$computerName-rawdata.txt에 기록했습니다."
Write-Host "스크립트 실행이 완료되었습니다."
