# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    Exit
}

# 콘솔 환경 설정
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Host "------------------------------------------설정 시작---------------------------------------"
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
$installPath = Get-Location
$installPath.Path | Out-File -FilePath "$rawDir\install_path.txt"
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Host "------------------------------------------IIS 설정---------------------------------------"
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

Write-Host "------------------------------------------설정 종료---------------------------------------"

Write-Host "------------------------------------------W-37 점검 시작---------------------------------------"
$ftpService = Get-Service -Name "MSFTPSVC" -ErrorAction SilentlyContinue
If ($ftpService.Status -eq "Running") {
    "W-37,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
취약점 발견
Microsoft FTP Service가 실행 중인 것이 확인되었습니다.
조치 방안
FTP 서비스가 활성화 되어있으므로, 필요하지 않은 경우 비활성화 해주세요.
조치 완료
FTP 서비스가 활성화 되어있기 때문에 취약점이 존재합니다.
"@
} Else {
    "W-37,안전,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
취약점 미발견
Microsoft FTP Service가 실행 중이지 않습니다.
조치 방안
FTP 서비스가 비활성화 되어있습니다.
조치 완료
FTP 서비스가 비활성화 되어있기 때문에 안전합니다.
"@
}
Write-Host
