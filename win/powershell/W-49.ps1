# 관리자 권한 확인 및 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "White"
Clear-Host

Write-Host "------------------------------------------Setting---------------------------------------"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 이전 디렉토리 삭제 및 새 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# DNS 서비스 동적 업데이트 설정 검사
Write-Host "------------------------------------------W-49------------------------------------------"
$dnsService = Get-Service -Name "DNS" -ErrorAction SilentlyContinue
if ($dnsService.Status -eq "Running") {
    $allowUpdate = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" -ErrorAction SilentlyContinue).AllowUpdate
    if ($allowUpdate -eq "0") {
        "W-49,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인
DNS 서비스가 활성화되어 있으나 동적 업데이트 권한이 설정되어 있지 않은 경우 안전
조치 방안
DNS 서비스가 활성화되어 있으나 동적 업데이트 권한이 설정되어 있지 않아 안전
"@ | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-49,X,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인
DNS 서비스가 활성화되어 있으나 동적 업데이트 권한이 설정되어 있는 경우 위험
조치 방안
DNS 서비스가 활성화되어 있으나 동적 업데이트 권한을 제한적으로 설정해야 함
"@ | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-49,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "DNS 서비스가 비활성화되어 있는 경우 안전" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
}
Write-Host "-------------------------------------------end------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
