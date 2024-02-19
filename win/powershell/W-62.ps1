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

# ESTsoft 및 AhnLab 소프트웨어 설치 여부 확인
$softwareKeys = @("HKLM:\SOFTWARE\ESTsoft", "HKLM:\SOFTWARE\AhnLab")
$w62Result = @()

foreach ($key in $softwareKeys) {
    If (Test-Path $key) {
        $w62Result += Get-ChildItem -Path $key -Recurse
    }
}

If ($w62Result.Count -gt 0) {
    "W-62,O,| 취약: ESTsoft 또는 AhnLab 소프트웨어가 설치된 경우" | Out-File "$resultDirectory\W-Window-${computerName}-result.txt"
} Else {
    "W-62,C,| 안전: ESTsoft 또는 AhnLab 소프트웨어가 설치되지 않은 경우" | Out-File "$resultDirectory\W-Window-${computerName}-result.txt"
}

# 결과 요약
Get-Content -Path "$resultDirectory\W-Window-*" | Out-File -FilePath "$resultDirectory\security_audit_summary.txt"

Write-Output "Results have been saved to $resultDirectory\security_audit_summary.txt."

# 정리 작업
Remove-Item -Path "$rawDirectory\*" -Force

Write-Output "Script has completed."
