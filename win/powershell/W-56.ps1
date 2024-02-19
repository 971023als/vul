# 관리자 권한 확인 및 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 환경 설정
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$Host.UI.RawUI.ForegroundColor = "Green"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_$computerName`_raw"
$resultDir = "C:\Window_$computerName`_result"

# 디렉토리 준비
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 로컬 보안 정책 및 시스템 정보 수집
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 정보 수집
if (Test-Path $env:windir\System32\inetsrv\config\applicationHost.config) {
    Get-Content "$env:windir\System32\inetsrv\config\applicationHost.config" | Out-File "$rawDir\iis_setting.txt"
}

# 보안 소프트웨어 설치 여부 확인
$estsoft = Get-ItemProperty -Path HKLM:\SOFTWARE\ESTsoft -ErrorAction SilentlyContinue
$ahnLab = Get-ItemProperty -Path HKLM:\SOFTWARE\AhnLab -ErrorAction SilentlyContinue

# 결과 기록
if ($estsoft -or $ahnLab) {
    "W-56,C,| 보안 프로그램 설치 확인됨" | Out-File "$resultDir\W-Window-$computerName-result.txt"
} else {
    "W-56,O,| 보안 프로그램 설치되지 않음" | Out-File "$resultDir\W-Window-$computerName-result.txt"
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 결과 요약 메일로 보내기 예시 (실제 작동하지 않음)
# Send-MailMessage -To "admin@example.com" -Subject "Security Audit Summary" -Body (Get-Content "$resultDir\security_audit_summary.txt" -Raw) -SmtpServer "your.smtp.server"

Write-Host "Results have been saved to $resultDir\security_audit_summary.txt."

# 정리 작업
Remove-Item -Path "$rawDir\*" -Force

Write-Host "Script has completed."
