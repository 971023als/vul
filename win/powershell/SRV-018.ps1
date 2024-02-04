# 관리자 권한으로 스크립트 실행 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-File",($MyInvocation.MyCommand.Definition) -Verb RunAs
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 기존 디렉터리 삭제 및 새 디렉터리 생성
Remove-Item -Path $rawDir, $resultDir -Force -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory -Force

# 로컬 보안 정책 및 시스템 정보 수집
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
Get-SystemInfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 수집
if (Test-Path $env:windir\System32\Inetsrv\Config\applicationHost.Config) {
    Get-Content $env:windir\System32\Inetsrv\Config\applicationHost.Config | Out-File "$rawDir\iis_setting.txt"
    Get-Content "$rawDir\iis_setting.txt" | Select-String "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
}

# 하드디스크 기본 공유 진단
Write-Host "Checking for unnecessary hard disk shares..."
$shares = Get-WmiObject -Class Win32_Share -Filter "Name='C$' OR Name='D$'"
if ($shares) {
    Write-Host "Default shares found. Consider removing them if not needed."
} else {
    Write-Host "No default shares found. This is good for security."
}

# AutoShareServer 및 AutoShareWks 레지스트리 값 확인
Write-Host "Checking AutoShareServer and AutoShareWks registry values..."
$autoShareWks = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name AutoShareWks -ErrorAction SilentlyContinue
$autoShareServer = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name AutoShareServer -ErrorAction SilentlyContinue

if ($autoShareWks -and $autoShareWks.AutoShareWks -ne 0) {
    Write-Host "AutoShareWks is set. Consider setting it to 0 if not needed."
} else {
    Write-Host "AutoShareWks is not set. This is good for security on workstations."
}

if ($autoShareServer -and $autoShareServer.AutoShareServer -ne 0) {
    Write-Host "AutoShareServer is set. Consider setting it to 0 if not needed."
} else {
    Write-Host "AutoShareServer is not set. This is good for security on servers."
}

# SMTP 서비스 실행 여부 확인
Write-Host "Checking for unnecessary SMTP service execution..."
$smtpService = Get-Service -Name SMTP -ErrorAction SilentlyContinue
if ($smtpService -and $smtpService.Status -eq 'Running') {
    "$smtpService.DisplayName is running." | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
} else {
    "SMTP Service is not running or not installed." | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
}
