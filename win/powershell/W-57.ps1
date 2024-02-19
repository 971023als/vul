# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell.exe -ArgumentList "Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs"
    exit
}

# 환경 설정
$OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$Host.UI.RawUI.ForegroundColor = "Green"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 디렉토리 준비
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir -Force | Out-Null

# 로컬 보안 정책 및 시스템 정보 수집
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = "$env:windir\System32\inetsrv\config\applicationHost.config"
If (Test-Path $applicationHostConfig) {
    Get-Content $applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
}

# 감사 정책 설정 검사
$securitySettings = Get-Content "$rawDir\Local_Security_Policy.txt"
$auditSettings = @(
    "AuditLogonEvents", "AuditPrivilegeUse", "AuditPolicyChange", "AuditDSAccess", "AuditAccountLogon", "AuditAccountManage"
)
$auditResults = foreach ($setting in $auditSettings) {
    if ($securitySettings -match "$setting.*3") {
        "$setting: Success and Failure"
    } elseif ($securitySettings -match "$setting.*2") {
        "$setting: Failure"
    } elseif ($securitySettings -match "$setting.*1") {
        "$setting: Success"
    } else {
        "$setting: No Auditing"
    }
}

$auditResults | Out-File "$rawDir\W-57.txt"
if ($auditResults -match "No Auditing") {
    "W-57,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt"
    "Policy settings are not correctly configured for some audit events." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    $auditResults | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-57,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt"
    "All audit events are correctly configured." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    $auditResults | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

Write-Host "Results have been saved to $resultDir\security_audit_summary.txt."

# 정리 작업
Remove-Item "$rawDir\*" -Force

Write-Host "Script has completed."
