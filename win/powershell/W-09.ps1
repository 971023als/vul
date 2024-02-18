# Check for Administrator privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "관리자 권한이 필요합니다..."
    $scriptPath = $MyInvocation.MyCommand.Definition
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
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
Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt" -Append

# Password Complexity Check
$localSecurityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$passwordComplexity = $localSecurityPolicy | Where-Object { $_ -match "PasswordComplexity" }

If ($passwordComplexity -match "1") {
    $resultText = "W-09,O,| 정책 충족: '비밀번호 복잡성 요구 사항이 '활성화'로 설정되어 있습니다."
} Else {
    $resultText = "W-09,X,| 정책 미충족: '비밀번호 복잡성 요구 사항이 '비활성화'로 설정되어 있습니다."
}

# Output the result
$resultText | Out-File "$resultDir\W-Window-$computerName-result.txt"
$passwordComplexity | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append

# Save Raw Data
$localSecurityPolicy | Where-Object { $_ -match "PasswordComplexity" } | Out-File "$resultDir\W-Window-$computerName-rawdata.txt"
