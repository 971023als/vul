# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    exit
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

# W-46 SNMP 서비스 상태 검사
Write-Host "------------------------------------------W-46 SNMP 서비스 상태 검사------------------------------------------"
$snmpService = Get-Service -Name "SNMP" -ErrorAction SilentlyContinue
if ($snmpService -and $snmpService.Status -eq "Running") {
    "W-46,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
SNMP 서비스가 활성화되어 있습니다.
이는 보안상 위험할 수 있으므로, 필요하지 않은 경우 비활성화하는 것이 권장됩니다.
"@
} else {
    "W-46,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
SNMP 서비스가 실행되지 않고 있습니다.
이는 추가 보안을 위한 긍정적인 상태입니다.
"@
}
Write-Host "-------------------------------------------end------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
