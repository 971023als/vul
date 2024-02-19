# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs"
    exit
}

# 콘솔 환경 설정
chcp 437 > $null
$Host.UI.RawUI.BackgroundColor = "DarkGreen"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# 기본 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_$($computerName)_raw"
$resultDir = "C:\Window_$($computerName)_result"

# 디렉터리 준비
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir -Force | Out-Null

# 시스템 정보 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"

# ODBC 데이터 소스 설정 검사
Write-Host "------------------------------------------ODBC Data Sources Setting------------------------------------------"
$odbcDataSources = reg query "HKLM\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources"
If ($odbcDataSources) {
    "W-52,O,| ODBC Data Sources are configured, which might be unnecessary and pose a vulnerability." | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
} Else {
    "W-52,X,| No unnecessary ODBC Data Sources are configured, system is safe." | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
}

Write-Host "------------------------------------------End of ODBC Data Sources Setting------------------------------------------"

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Remove-Item -Path $rawDir\* -Force

Write-Host "Script has completed. Results have been saved to $resultDir\security_audit_summary.txt."
