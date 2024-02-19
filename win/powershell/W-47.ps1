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

# W-47 SNMP 서비스 커뮤니티 스트링 검사
Write-Host "------------------------------------------W-47 SNMP 서비스 커뮤니티 스트링 검사------------------------------------------"
$snmpService = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($snmpService.Status -eq "Running") {
    $communities = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities"
    if ($communities -and ($communities.PSObject.Properties.Name -contains "public" -or $communities.PSObject.Properties.Name -contains "private")) {
        "W-47,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
SNMP 서비스가 실행 중이며 기본 커뮤니티 스트링인 'public' 또는 'private'를 사용하고 있습니다.
이는 네트워크에 보안 취약점을 노출시킬 수 있습니다.
적절한 보안 조치를 취하여 커뮤니티 스트링을 변경하거나 제거해야 합니다.
"@ | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-47,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        "SNMP 서비스가 실행 중이지만, 'public' 또는 'private'와 같은 기본 커뮤니티 스트링을 사용하고 있지 않습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-47,정보,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
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
