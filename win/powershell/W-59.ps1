# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs" -Wait
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawDirectory = "C:\Window_${computerName}_raw"
$resultDirectory = "C:\Window_${computerName}_result"

# 디렉토리 초기화 및 생성
Remove-Item -Path $rawDirectory, $resultDirectory -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDirectory, $resultDirectory | Out-Null

# 시스템 정보 수집
secedit /export /cfg "$rawDirectory\Local_Security_Policy.txt"
systeminfo | Out-File "$rawDirectory\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = "$env:windir\System32\Inetsrv\Config\applicationHost.config"
If (Test-Path $applicationHostConfig) {
    Get-Content $applicationHostConfig | Out-File "$rawDirectory\iis_setting.txt"
}

# Remote Registry 서비스 상태 검사
$remoteRegistryStatus = Get-Service -Name "RemoteRegistry" -ErrorAction SilentlyContinue
$resultText = ""

If ($remoteRegistryStatus -and $remoteRegistryStatus.Status -eq 'Running') {
    $resultText = "W-59,X,|`n정책 설정`nRemote Registry Service가 활성화되어 있는 경우 위험`n주의 사항`nRemote Registry Service가 활성화되어 있으면 위험`n참고 사항`nRemote Registry Service가 활성화되어 있으면 비활성화 필요`n|"
} Else {
    $resultText = "W-59,O,|`n정책 설정`nRemote Registry Service가 비활성화되어 있는 경우 안전`n주의 사항`nRemote Registry Service가 비활성화되어 있으면 안전`n참고 사항`nRemote Registry Service가 비활성화되어 있으면 추가 조치 필요 없음`n|"
}

# 결과 저장
$resultText | Out-File -FilePath "$resultDirectory\W-Window-${computerName}-result.txt"

# 결과 요약
Get-Content -Path "$resultDirectory\W-Window-*" | Out-File -FilePath "$resultDirectory\security_audit_summary.txt"

Write-Host "Results have been saved to $resultDirectory\security_audit_summary.txt."

# 정리 작업
Remove-Item -Path "$rawDirectory\*" -Force

Write-Host "Script has completed."
