# 관리자 권한 확인
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "$PSCommandPath" -Verb RunAs
    exit
}

# 콘솔 창 설정
$OutputEncoding = [System.Text.Encoding]::GetEncoding(949)
[Console]::ForegroundColor = 'Green'

# 디렉터리 설정
$computerName = $env:COMPUTERNAME
$rawPath = "C:\Window_${computerName}_raw"
$resultPath = "C:\Window_${computerName}_result"
Remove-Item -Path $rawPath, $resultPath -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawPath, $resultPath | Out-Null

# 로컬 보안 정책 내보내기 및 파일 생성
secedit /export /cfg "$rawPath\Local_Security_Policy.txt" | Out-Null
New-Item -ItemType File -Path "$rawPath\compare.txt" | Out-Null

# 시스템 정보 내보내기
systeminfo | Out-File -FilePath "$rawPath\systeminfo.txt"

# IIS 설정 내보내기
$applicationHostConfig = Get-Content -Path $env:WinDir\System32\Inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File -FilePath "$rawPath\iis_setting.txt"
$applicationHostConfig | Select-String -Pattern "physicalPath|bindingInformation" | Out-File -FilePath "$rawPath\iis_path1.txt"

# MetaBase.xml 내보내기
Get-Content -Path "C:\WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File -FilePath "$rawPath\iis_setting.txt" -Append

# 감사 실패 시 시스템 충돌 설정 확인
$policyValue = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "CrashOnAuditFail"
$resultFile = "$resultPath\W-Window-$computerName-result.txt"

if ($policyValue.CrashOnAuditFail -eq 0) {
    "W-67,O,| 감사 실패 시 시스템 충돌 설정[CrashOnAuditFail]이 보안에 적합하게 설정되었습니다." | Out-File -FilePath $resultFile
} else {
    "W-67,X,| 감사 실패 시 시스템 충돌 설정[CrashOnAuditFail]이 보안 요구사항에 맞게 설정되지 않았습니다." | Out-File -FilePath $resultFile
}

# 결과 요약
Get-Content -Path "$resultPath\W-Window-*" | Out-File -FilePath "$resultPath\security_audit_summary.txt"

# 결과 메시지 출력
Write-Host "결과가 $resultPath\security_audit_summary.txt 에 저장되었습니다."

# 정리 작업
Remove-Item -Path "$rawPath\*" -Force

Write-Host "스크립트를 종료합니다."
