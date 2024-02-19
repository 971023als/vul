# 관리자 권한 확인 및 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "$PSCommandPath" -Verb RunAs
    exit
}

# 콘솔 환경 설정
$host.UI.RawUI.ForegroundColor = "Green"
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir | Out-Null
$null = secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -ItemType File -Path "$rawDir\compare.txt" -Value $null

# 설치 경로 정보
$installPath = (Get-Location).Path
Add-Content -Path "$rawDir\install_path.txt" -Value $installPath

# 시스템 정보
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
Get-Content "C:\WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt" -Append

# W-66 검사 시작
$securityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$remoteShutdownPrivilege = $securityPolicy | Where-Object {$_ -match "SeRemoteShutdownPrivilege"}
if ($remoteShutdownPrivilege -match ",\*S-1-5-32-544" -or $remoteShutdownPrivilege -match "\*S-1-5-32-544,") {
    "W-66,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "원격에서 시스템 종료 권한이 Administrators 그룹에만 부여되어 있어 취약" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-66,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "원격에서 시스템 종료 권한이 안전하게 설정되어 있어 추가 조치 필요 없음" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 결과 출력 및 정리
Write-Host "결과가 $resultDir\security_audit_summary.txt에 저장되었습니다."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
