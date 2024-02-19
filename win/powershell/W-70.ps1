# 관리자 권한 확인 및 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"" + $myinvocation.MyCommand.Definition + "`" " + $args
    Start-Process "PowerShell" -Verb RunAs -ArgumentList $arguments
    exit
}

# 환경 설정
$OutputEncoding = [System.Text.Encoding]::UTF8
$PSCulture = [System.Globalization.CultureInfo]::InvariantCulture
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 기존 데이터 삭제 및 디렉터리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 로컬 보안 정책 내보내기
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null

# 비교 파일 생성
New-Item -Path "$rawDir\compare.txt" -ItemType File | Out-Null

# 설치 경로 저장
$installPath = Get-Location
$installPath.Path | Out-File -FilePath "$rawDir\install_path.txt"

# 시스템 정보 저장
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 수집
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath", "bindingInformation" | Out-File -FilePath "$rawDir\iis_path1.txt"

# W-70 검사
$localSecurityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$allocateDASD = $localSecurityPolicy | Where-Object { $_ -match "AllocateDASD" -and $_ -match "0" }

if ($allocateDASD) {
    "W-70,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "디스크 할당 권한 변경이 관리자만 가능하도록 설정되어 있는 상태입니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-70,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "디스크 할당 권한 변경이 관리자만 가능하도록 설정되지 않았습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

Write-Host "결과가 $resultDir\security_audit_summary.txt에 저장되었습니다."

# 정리 작업
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
