# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs" -Wait
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDirectory = "C:\Window_${computerName}_raw"
$resultDirectory = "C:\Window_${computerName}_result"

# 디렉토리 초기화 및 생성
Remove-Item -Path $rawDirectory, $resultDirectory -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDirectory, $resultDirectory | Out-Null

# 시스템 정보 수집
secedit /export /cfg "$rawDirectory\Local_Security_Policy.txt"
systeminfo | Out-File "$rawDirectory\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = "$env:windir\System32\Inetsrv\Config\applicationHost.config"
If (Test-Path $applicationHostConfig) {
    Get-Content $applicationHostConfig | Out-File "$rawDirectory\iis_setting.txt"
}

# 이벤트 로그 설정 검사
$eventLogKeys = @("Application", "Security", "System")
foreach ($key in $eventLogKeys) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\$key"
    $maxSize = (Get-ItemProperty -Path $path -Name "MaxSize").MaxSize
    $retention = (Get-ItemProperty -Path $path -Name "Retention").Retention
    If ($maxSize -lt 10485760 -or $retention -eq 0) {
        "W-60,X,|" | Out-File -Append "$resultDirectory\W-Window-${computerName}-result.txt"
    } Else {
        "W-60,O,|" | Out-File -Append "$resultDirectory\W-Window-${computerName}-result.txt"
    }
    "MaxSize for $key: $maxSize, Retention for $key: $retention" | Out-File -Append "$rawDirectory\Eventlog.txt"
}

# 결과 요약
Get-Content -Path "$resultDirectory\W-Window-*" | Out-File -FilePath "$resultDirectory\security_audit_summary.txt"

Write-Host "Results have been saved to $resultDirectory\security_audit_summary.txt."

# 정리 작업
Remove-Item -Path "$rawDirectory\*" -Force

Write-Host "Script has completed."
