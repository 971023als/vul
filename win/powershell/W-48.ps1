# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    Exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Host "------------------------------------------설정 시작---------------------------------------"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 이전 디렉토리 삭제 및 새 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# W-48 SNMP 허용된 관리자 설정 검사
Write-Host "------------------------------------------W-48 SNMP 허용된 관리자 설정 검사------------------------------------------"
$snmpService = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($snmpService.Status -eq "Running") {
    $permittedManagers = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers"
    if ($permittedManagers -and $permittedManagers.PSObject.Properties.Value) {
        "W-48,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
SNMP 서비스가 실행 중이며 허용된 관리자가 구성되어 있습니다.
해당 설정은 네트워크 보안을 강화하는 데 도움이 됩니다.
"@ | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-48,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
SNMP 서비스가 실행 중이지만 허용된 관리자가 명확하게 구성되지 않았습니다.
SNMP 관리를 위한 보안 조치로 허용된 관리자를 명확하게 설정하는 것이 권장됩니다.
"@ | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-48,정보,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "SNMP 서비스가 실행되지 않고 있습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
}
Write-Host "-------------------------------------------end------------------------------------------"

# 결과 요약 및 저장
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
