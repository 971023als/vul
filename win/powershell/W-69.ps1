# 관리자 권한 확인 및 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $PSCommandPath -Verb RunAs
    exit
}

# 콘솔 설정
$OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.ForegroundColor = "Green"

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_$($computerName)_raw"
$resultDir = "C:\Window_$($computerName)_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
mkdir $rawDir, $resultDir | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null | Out-Null

# 설치 경로 정보
$installPath = (Get-Location).Path
Add-Content -Path "$rawDir\install_path.txt" -Value $installPath

# 시스템 정보 수집
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 수집
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath", "bindingInformation" | Out-File "$rawDir\iis_path1.txt"
Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt" -Append

# W-69 검사 시작
$autoAdminLogon = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon").AutoAdminLogon
if ($autoAdminLogon -eq "1")
{
    "W-69,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "AutoAdminLogon 설정이 활성화되어 있어 보안에 취약합니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    (reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | Select-String "AutoAdminLogon") | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}
else
{
    "W-69,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "AutoAdminLogon 설정이 비활성화되어 있습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    (reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" | Select-String "AutoAdminLogon") | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 결과 및 정리
Write-Host "결과가 $resultDir\security_audit_summary.txt에 저장되었습니다."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
