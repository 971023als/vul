# 관리자 권한으로 스크립트 실행 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDirectory = "C:\Window_${computerName}_raw"
$resultDirectory = "C:\Window_${computerName}_result"

# 기존 정보 삭제 및 새 디렉터리 생성
Remove-Item -Path $rawDirectory, $resultDirectory -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDirectory, $resultDirectory -Force | Out-Null

# 시스템 정보 수집
secedit /export /cfg "$rawDirectory\Local_Security_Policy.txt"
systeminfo | Out-File "$rawDirectory\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
If (Test-Path $applicationHostConfig) {
    Get-Content $applicationHostConfig | Out-File "$rawDirectory\iis_setting.txt"
}

# SAM 파일 권한 분석
$samPermissions = icacls "$env:systemroot\system32\config\SAM"
If ($samPermissions -notmatch 'Administrator|System') {
    "W-63,O,| 취약: Administrator 또는 System 그룹 외 다른 권한이 발견되었습니다." | Out-File "$resultDirectory\W-Window-$computerName-result.txt"
} Else {
    "W-63,X,| 안전: Administrator 및 System 그룹 권한만이 설정되어 있습니다." | Out-File "$resultDirectory\W-Window-$computerName-result.txt"
}

# 결과 요약
Get-Content "$resultDirectory\W-Window-*" | Out-File "$resultDirectory\security_audit_summary.txt"

# 결과 출력
Write-Host "결과가 $resultDirectory\security_audit_summary.txt 에 저장되었습니다."

# 정리 작업
Remove-Item -Path "$rawDirectory\*" -Force

# 스크립트 종료
Write-Host "스크립트를 종료합니다."
