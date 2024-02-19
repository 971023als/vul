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

# 시스템 정보 수집
$systemInfo = systeminfo
$systemInfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 검사
$iisConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$iisConfig | Out-File -FilePath "$rawDir\iis_setting.txt"

# W-50: 서비스 비활성화 권장
Write-Host "------------------------------------------W-50------------------------------------------"
"상태 확인" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"HTTP, FTP, SMTP 서비스가 필요 없는 경우 비활성화 권장" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
"필요하지 않은 서비스는 비활성화하여 Windows Server 2012 이상에서 안전함" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append

# 결과 요약
Write-Host "결과가 $resultDir\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
