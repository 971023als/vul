# Check for Administrator privileges
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "관리자 권한을 요청하는 중..."
    $currentScript = $MyInvocation.MyCommand.Definition
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$currentScript`"" -Verb RunAs
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
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
mkdir $rawDir, $resultDir
New-Item -Path "$rawDir\compare.txt" -ItemType File

# Get installation path
$installPath = Get-Location
"$installPath" | Out-File "$rawDir\install_path.txt"

# Collect system information
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS Configuration
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt" -Append

# Check for "test" or "Guest" in Administrators group
$administrators = net localgroup Administrators
$nonCompliantAccounts = $administrators | Where-Object { $_ -match "test|Guest" }

If ($nonCompliantAccounts) {
    $result = @"
W-06,X,|
비준수 상태 감지됨
관리자 그룹에는 임시 또는 게스트 계정이 포함되어서는 안 됩니다.
권장 조치: 'test' 및 'Guest' 계정을 관리자 그룹에서 제거하세요.
추가 세부 사항: 'test' 및 'Guest' 계정의 관리자 그룹 내 존재는 보안 위험을 초래합니다.
"@
} Else {
    $result = @"
W-06,C,|
준수 상태 감지됨
관리자 그룹에 임시 또는 게스트 계정이 포함되지 않아 보안 정책을 준수합니다.
이 설정은 승인된 사용자만 관리자 권한을 가지도록 합니다.
"@
}

# Output the result
$result | Out-File "$resultDir\W-Window-$computerName-result.txt"
$administrators | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append

# Write raw data
$administrators | Out-File "$resultDir\W-Window-$computerName-rawdata.txt"
