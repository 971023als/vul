# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Start-Process PowerShell -ArgumentList "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs" -Verb RunAs
    Exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 기존 데이터 삭제 및 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory

# 로컬 보안 정책 내보내기
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"

# 시스템 정보 저장
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath", "bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# W-73 검사: 프린터 드라이버 추가 권한 검증
$securityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$addPrinterDrivers = $securityPolicy | Where-Object { $_ -match "AddPrinterDrivers" }

If ($addPrinterDrivers -match "1") {
    "W-73,O,| 프린터 드라이버 추가 권한 설정이 적절합니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt"
} Else {
    "W-73,X,| 프린터 드라이버 추가 권한 설정이 부적절합니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt"
}

# 결과 요약 생성
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 이메일 결과 요약 보내기 (예시, 실제 작동 안 함)
# Send-MailMessage -To "admin@example.com" -Subject "Security Audit Summary" -Body (Get-Content "$resultDir\security_audit_summary.txt" -Raw) -SmtpServer "smtp.example.com"

# 정리 작업
Remove-Item -Path "$rawDir\*" -Force

"스크립트가 완료되었습니다."
