# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 환경 설정
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$Host.UI.RawUI.ForegroundColor = "Green"

# 변수 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 디렉터리 생성 및 초기화
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction Ignore
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 시스템 정보 및 IIS 설정 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"
Get-Content "$env:windir\System32\inetsrv\config\applicationHost.config" | Out-File "$rawDir\iis_setting.txt"

# 핫픽스 검사
$hotfixCheck = Get-HotFix -Id "KB3214628" -ErrorAction SilentlyContinue
if ($hotfixCheck) {
    "W-55,O,|" + " Hotfix KB3214628 is installed, which may indicate a vulnerability." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-55,C,|" + " Hotfix KB3214628 is not installed, indicating a secure state." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 이메일 결과 요약 보내기 (예시, 실제로는 작동하지 않음)
# Send-MailMessage -To "admin@example.com" -Subject "Security Audit Summary" -Body (Get-Content "$resultDir\security_audit_summary.txt" -Raw) -SmtpServer "smtp.example.com"

Write-Host "Results have been saved to $resultDir\security_audit_summary.txt."

# 정리 작업
Remove-Item "$rawDir\*" -Force

Write-Host "Script has completed."
