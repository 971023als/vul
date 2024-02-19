# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell.exe -ArgumentList "Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs"
    exit
}

# 환경 설정
$OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$Host.UI.RawUI.ForegroundColor = "Green"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 디렉토리 준비
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir -Force | Out-Null

# 로컬 보안 정책 및 시스템 정보 수집
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = "$env:windir\System32\inetsrv\config\applicationHost.config"
If (Test-Path $applicationHostConfig) {
    Get-Content $applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
}

# W-58 정책 설정 기록
$resultFile = "$resultDir\W-Window-${computerName}-result.txt"
"------------------------------------------W-58------------------------------------------" | Out-File $resultFile
"W-58,C,|" | Out-File $resultFile -Append
"정책 설정" | Out-File $resultFile -Append
"로그온 이벤트 및 관련 보안 로깅, 감사, 리포트 작성 및 보안 로그 위치를 관리하는데 필요한 정책 설정" | Out-File $resultFile -Append
"주의 사항" | Out-File $resultFile -Append
"로그 저장 정책 및 감사를 통해 리포트를 작성하고 보안 로그를 관리하는데 필요한 정책을 검토 및 설정 필요" | Out-File $resultFile -Append
"참고 사항" | Out-File $resultFile -Append
"로그 저장 정책 및 감사를 통해 리포트를 작성하고 보안 로그를 관리하는데 필요한 정책을 검토 및 설정 필요" | Out-File $resultFile -Append
"|" | Out-File $resultFile -Append

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

Write-Output "Results have been saved to $resultDir\security_audit_summary.txt."

# 정리 작업
Remove-Item "$rawDir\*" -Force

Write-Output "Script has completed."
