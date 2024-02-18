# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    $script = "-File `"" + $MyInvocation.MyCommand.Definition + "`""
    Start-Process PowerShell.exe -ArgumentList $script -Verb RunAs
    Exit
}

# 콘솔 환경 설정 및 초기 설정
chcp 437 | Out-Null
$host.UI.RawUI.ForegroundColor = "Green"

$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
mkdir $rawDir, $resultDir | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null
Set-Location -Path $rawDir
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# W-21 특정 서비스의 실행 상태 확인
$servicesToCheck = @("Alerter", "ClipBook", "Messenger", "Simple TCP/IP Services")
$servicesStatus = Get-Service | Where-Object { $servicesToCheck -contains $_.DisplayName } | Select-Object DisplayName, Status
$servicesStatus | Out-File "$rawDir\W-21.txt"

# 결과 분석 및 출력
if ($servicesStatus) {
    "W-21,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "위험 상태: 시스템에 비활성화되어야 하는 서비스가 설치되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    $servicesStatus | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} else {
    "W-21,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "정상 상태: 시스템에 비활성화되어야 하는 서비스가 설치되지 않았습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}

# W-21 데이터 캡처
$servicesStatus | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
Get-Service | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
