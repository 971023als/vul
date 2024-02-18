# Check for Administrator privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "관리자 권한이 필요합니다..."
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Set console preferences
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# Initial setup
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File

# System Information
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS Configuration
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
(Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml") -join "`n" | Out-File "$rawDir\iis_setting.txt" -Append

# Analyze Security Policy
$securityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$lockoutDuration = ($securityPolicy | Where-Object { $_ -match "LockoutDuration" }).Split("=")[1].Trim()
$resetLockoutCount = ($securityPolicy | Where-Object { $_ -match "ResetLockoutCount" }).Split("=")[1].Trim()

$resultText = ""
If ($resetLockoutCount -gt 59) {
    If ($lockoutDuration -gt 59) {
        $resultText = "W-08,O,| 정책 충족: '잠금 지속 시간'과 '잠금 카운트 리셋 시간'이 설정 요구사항을 충족합니다."
    } Else {
        $resultText = "W-08,X,| 정책 미충족: '잠금 지속 시간' 또는 '잠금 카운트 리셋 시간'이 설정 요구사항을 미충족합니다."
    }
} Else {
    $resultText = "W-08,X,| 정책 미충족: '잠금 지속 시간' 또는 '잠금 카운트 리셋 시간'이 설정 요구사항을 미충족합니다."
}

# Output the result
$resultText | Out-File "$resultDir\W-Window-$computerName-result.txt"
$securityPolicy | Where-Object { $_ -match "LockoutDuration|ResetLockoutCount" } | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append

# Raw Data
$securityPolicy | Where-Object { $_ -match "ResetLockoutCount|LockoutDuration" } | Out-File "$resultDir\W-Window-$computerName-rawdata.txt"
