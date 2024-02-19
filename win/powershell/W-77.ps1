# 관리자 권한으로 실행되지 않았다면 스크립트를 관리자 권한으로 다시 실행
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 기존 폴더 삭제 및 새 폴더 생성
Remove-Item $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 로컬 보안 정책 내보내기
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null

# 시스템 정보 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 파일 읽기
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"

# 설정 분석 및 결과 저장 (예시)
# 주의: 실제 분석 로직은 설정에 따라 다를 수 있습니다.

# 임시 파일 및 폴더 삭제
Remove-Item "$rawDir\*" -Force
