# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process PowerShell -Verb RunAs -ArgumentList "-File `"$PSCommandPath`"", "-ExecutionPolicy Bypass"
    Exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 기존 데이터 삭제 및 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory

# 로컬 보안 정책 내보내기
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"

# 시스템 정보 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath", "bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# W-75 검사: 로그인 법적 고지 검증
$LegalNoticeCaption = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").LegalNoticeCaption
$LegalNoticeText = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").LegalNoticeText

If ($LegalNoticeCaption -ne $null -or $LegalNoticeText -ne $null) {
    "W-75,X,| 설정 미완료: 로그인 시 법적 고지가 설정되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt"
} Else {
    "W-75,O,| 설정 완료: 로그인 시 법적 고지가 설정되지 않았습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt"
}

# 결과 요약 생성
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 이메일 결과 요약 보내기 (예시, 실제 작동 안 함)
# 이 부분은 실제 환경에 맞게 SMTP 설정이 필요합니다.

# 정리 작업
Remove-Item -Path "$rawDir\*" -Force

"스크립트가 완료되었습니다."
