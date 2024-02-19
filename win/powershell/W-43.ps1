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

# W-43 OS 버전 확인
Write-Host "------------------------------------------W-43 OS 버전 확인------------------------------------------"
$systemInfo = Get-Content "$rawDir\systeminfo.txt"
$osVersion = $systemInfo | Where-Object { $_ -match "OS Version" }

"OS 버전 확인" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"시스템이 지원하는 OS 버전에 맞게 구성되어 있는지 확인합니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"조치 방안" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"필요한 경우 OS 업그레이드를 고려하십시오." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
$osVersion | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"조치 완료" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"필요한 경우 OS 업그레이드를 고려하여 보안을 강화하십시오." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append

Write-Host "-------------------------------------------end------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
