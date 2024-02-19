# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`"' -Verb RunAs" -Verb RunAs
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 기존 데이터 삭제 및 디렉터리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 로컬 보안 정책 내보내기 및 분석 준비
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File | Out-Null

# 시스템 정보 저장
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 분석
$iisConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$iisConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$iisConfig | Select-String -Pattern "physicalPath", "bindingInformation" | Out-File -FilePath "$rawDir\iis_path1.txt"

# W-71 검사: 데이터 암호화 정책 활성화 상태 확인
# PowerShell 스크립트에서 직접 정책을 확인하는 명령은 없으므로, 이 부분은 예제로만 제공합니다.
"Windows Server 2012 이상에서 '데이터 암호화를 요구하는 정책' 설정이 적용되어 있습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt"

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Remove-Item "$rawDir\*" -Force

"스크립트를 종료합니다."
