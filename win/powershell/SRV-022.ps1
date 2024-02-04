# 관리자 권한으로 스크립트 실행 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 코드 페이지 변경 및 초기 설정
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
Write-Host "------------------------------------------설정---------------------------------------" -ForegroundColor Green

Remove-Item -Path "C:\Window_$env:COMPUTERNAME_raw" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Window_$env:COMPUTERNAME_result" -Recurse -ErrorAction SilentlyContinue
New-Item -Path "C:\Window_$env:COMPUTERNAME_raw" -ItemType Directory
New-Item -Path "C:\Window_$env:COMPUTERNAME_result" -ItemType Directory

# 로컬 보안 정책 내보내기
secedit /EXPORT /CFG "C:\Window_$env:COMPUTERNAME_raw\Local_Security_Policy.txt" 2>$null
New-Item -Path "C:\Window_$env:COMPUTERNAME_raw\compare.txt" -ItemType File

# 시스템 정보 추출
systeminfo | Out-File -FilePath "C:\Window_$env:COMPUTERNAME_raw\systeminfo.txt"

# IIS 설정 추출
Write-Host "------------------------------------------IIS 설정-----------------------------------" -ForegroundColor Green
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "C:\Window_$env:COMPUTERNAME_raw\iis_setting.txt"

# SRV-022 정책 검사
Write-Host "------------------------------------------SRV-022 정책 검사------------------------------------------" -ForegroundColor Green
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$limitBlankPasswordUse = Get-ItemProperty -Path $regPath -Name "LimitBlankPasswordUse"

Write-Host "SRV-022 (Windows) 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡"

# "콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한" 정책을 확인합니다.
Write-Host "`"콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한`" 정책을 확인합니다..."
Write-Host "LimitBlankPasswordUse: $($limitBlankPasswordUse.LimitBlankPasswordUse)"

# 필요한 경우 정책을 강제로 설정하여 1로 설정 (선택 사항)
# Set-ItemProperty -Path $regPath -Name "LimitBlankPasswordUse" -Value 1

Write-Host "-------------------------------------------검사 완료------------------------------------------" -ForegroundColor Green
