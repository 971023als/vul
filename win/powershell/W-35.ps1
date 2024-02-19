# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    exit
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

# 설치 경로 저장
$installPath = (Get-Location).Path
$installPath | Out-File -FilePath "$rawDir\install_path.txt"

# 시스템 정보 저장
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

Write-Host "------------------------------------------W-35 WebDAV Security Check------------------------------------------"
$serviceStatus = (Get-Service W3SVC -ErrorAction SilentlyContinue).Status
if ($serviceStatus -eq "Running") {
    $webDavConfig = Select-String -Path "$env:Windows\System32\inetsrv\config\applicationHost.config" -Pattern "webdav"
    if ($webDavConfig) {
        $webDavConfig.Line | Out-File -FilePath "$rawDir\W-35-1.txt"
        Write-Host "WebDAV configurations need review. See W-35-1.txt for details."
    } else {
        Write-Host "WebDAV is properly configured or not present."
    }
} else {
    Write-Host "IIS Web Publishing Service is not running. No action required."
}
Write-Host "-------------------------------------------End of WebDAV Security Check------------------------------------------"

Write-Host "------------------------------------------결과 요약------------------------------------------"
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"
Write-Host "Results have been saved to $resultDir\security_audit_summary.txt."

Write-Host "-------------------------------------------Cleanup-------------------------------------------"
Write-Host "Performing cleanup..."
Remove-Item "$rawDir\*" -Force

Write-Host "Script has completed."
