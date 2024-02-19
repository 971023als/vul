# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs" -Wait
    exit
}

# 환경 설정
$Host.UI.RawUI.BackgroundColor = "DarkGreen"
$Host.UI.RawUI.ForegroundColor = "White"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
Clear-Host

# 변수 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 디렉터리 생성 및 초기화
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory -Force | Out-Null

# 시스템 정보 및 IIS 설정 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"
Get-Content "$env:windir\System32\inetsrv\config\applicationHost.config" | Out-File "$rawDir\iis_setting.txt"

# 스케줄러 작업 검사
$schedulerTasks = schtasks /query | Out-String
If ($schedulerTasks -notmatch "There are no entries in the list") {
    "W-54,O,| Scheduled tasks are present, which may indicate unauthorized tasks." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} Else {
    "W-54,C,| No scheduled tasks found, indicating a secure state." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Remove-Item "$rawDir\*" -Force

Write-Host "Script has completed. Results have been saved to $resultDir\security_audit_summary.txt."
