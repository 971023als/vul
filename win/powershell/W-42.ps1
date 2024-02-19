# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    $script = "-File `"$PSCommandPath`" $args"
    Start-Process PowerShell -ArgumentList $script -Verb RunAs
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

# W-42 웹 서비스 상태 점검 시작
Write-Host "------------------------------------------W-42 웹 서비스 상태 점검 시작------------------------------------------"
$webService = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
if ($webService.Status -eq "Running") {
    "W-42,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
상태 확인: 웹 서비스가 실행 중입니다.
웹 서비스의 실행은 다음과 같은 위험을 수반할 수 있습니다:
1. IIS가 필요하지 않는 경우
2. 구성이 취약하거나 최신 보안 패치가 적용되지 않은 경우
3. 기본 설치 옵션을 변경하지 않고 사용하는 경우
조치 방안: 필요에 따라 웹 서비스를 비활성화하거나 보안 설정을 강화하세요.
"@
} else {
    "W-42,정보,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "상태 확인: 웹 서비스가 실행되지 않거나 설치되지 않았습니다."
}
Write-Host "-------------------------------------------W-42 웹 서비스 상태 점검 종료------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
