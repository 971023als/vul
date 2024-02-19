# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    Exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Host "------------------------------------------Setting---------------------------------------"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 이전 디렉토리 삭제 및 새 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 로컬 보안 정책 내보내기 및 비교 파일 생성
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null

# 설치 경로 저장 및 시스템 정보 수집
$installPath = (Get-Location).Path
$installPath | Out-File -FilePath "$rawDir\install_path.txt"
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Host "------------------------------------------IIS Setting-----------------------------------"
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$bindingInfo = $applicationHostConfig | Select-String "physicalPath|bindingInformation"
$line = $bindingInfo -join "`n"
$line | Out-File -FilePath "$rawDir\line.txt"

1..5 | ForEach-Object {
    $filePath = "$rawDir\path$_.txt"
    $bindingInfo | ForEach-Object {
        $_.Line | Out-File -FilePath $filePath -Append
    }
}

# MetaBase.xml 추가 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Host "------------------------------------------end-------------------------------------------"

Write-Host "------------------------------------------W-36 NetBIOS Configuration Check------------------------------------------"
$netBIOSConfig = Get-ItemProperty HKLM:\SYSTEM\ControlSet001\Services\NetBT\Parameters\Interfaces\* | Where-Object { $_.NetbiosOptions -eq 2 }
If ($netBIOSConfig) {
    "W-36,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
Test
NetBIOS over TCP/IP is disabled, which is a secure configuration.
Test End
Summary
The system is configured securely with NetBIOS over TCP/IP disabled.
"@
} Else {
    "W-36,X,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
Test
Review required: NetBIOS over TCP/IP settings.
Test End
Summary
Attention needed: NetBIOS over TCP/IP may not be properly configured.
"@
}
Write-Host "-------------------------------------------end------------------------------------------"

Write-Host "------------------------------------------결과 요약------------------------------------------"
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"
Write-Host "Results have been saved to $resultDir\security_audit_summary.txt."

Write-Host "Performing cleanup..."
Remove-Item "$rawDir\*" -Force

Write-Host "Script has completed."
