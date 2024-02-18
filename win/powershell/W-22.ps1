# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
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
Remove-Item -Path $rawDir, $resultDir -Recurse -Force
mkdir $rawDir, $resultDir
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null
Set-Location -Path $rawDir
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Matches.Value >> "$rawDir\iis_path1.txt"
}

# W-22 "World Wide Web Publishing Service" 서비스 상태 확인
$serviceStatus = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
$httpPaths = Select-String -Path "$rawDir\iis_path1.txt" -Pattern "http"

If ($serviceStatus.Status -eq "Running") {
    "W-22,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "위험 상태: 'World Wide Web Publishing Service'가 활성화되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    $httpPaths | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} Else {
    "W-22,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "정상 상태: 'World Wide Web Publishing Service'가 비활성화되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}

# W-22 데이터 캡처
If ($serviceStatus.Status -eq "Running") {
    $serviceStatus | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
} Else {
    "World Wide Web Publishing Service is not running" | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
}
