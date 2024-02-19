# 관리자 권한 확인 및 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"", "-Verb", "RunAs"
    exit
}

# 콘솔 환경 설정
$OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$host.UI.RawUI.ForegroundColor = "Green"

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -ItemType File -Path "$rawDir\compare.txt" -Value $null

# 설치 경로 정보
$installPath = (Get-Location).Path
Add-Content -Path "$rawDir\install_path.txt" -Value $installPath

# 시스템 정보
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt" -Append

# W-68 검사
$restrictAnonymous = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\LSA").restrictanonymous
if ($restrictAnonymous -eq 1) {
    $restrictAnonymousSAM = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\LSA").RestrictAnonymousSAM
    if ($restrictAnonymousSAM -eq 1) {
        "W-68,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "익명 SAM 계정 접근을 제한하는 설정이 적절히 구성되었습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-68,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "익명 SAM 계정 접근을 제한하는 설정이 적절히 구성되지 않았습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-68,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "익명 계정 접근을 제한하는 설정이 적절히 구성되지 않았습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 결과 출력 및 정리
Write-Host "결과가 $resultDir\security_audit_summary.txt에 저장되었습니다."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
