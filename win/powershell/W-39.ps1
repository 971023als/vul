# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
If (-not $isAdmin) {
    $info = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    $info.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args"
    $info.Verb = "runas"
    [System.Diagnostics.Process]::Start($info)
    Exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
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
Set-Location -Path $rawDir
Get-Location | Out-File -FilePath "$rawDir\install_path.txt"
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Host "------------------------------------------IIS 설정-----------------------------------"
Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config" | Out-File -FilePath "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object { $_.Line } | Out-File -FilePath "$rawDir\iis_path1.txt"

# IIS 설정 분석 및 경로 저장
$line = Get-Content "$rawDir\iis_path1.txt" -Raw
$line | Out-File -FilePath "$rawDir\line.txt"

1..5 | ForEach-Object {
    $filePath = "$rawDir\path$_.txt"
    Get-Content "$rawDir\line.txt" | ForEach-Object {
        $_ | Out-File -FilePath $filePath -Append
    }
}

# MetaBase.xml 추가 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Host "------------------------------------------설정 종료-------------------------------------------"

# W-39 점검 시작
Write-Host "------------------------------------------W-39 점검 시작------------------------------------------"
If (Test-Path "$rawDir\ftp_config.txt") {
    $ftpConfig = Get-Content "$rawDir\ftp_config.txt"
    $anonymousAuth = $ftpConfig | Where-Object { $_ -match 'anonymousAuthentication enabled="true"' }

    If ($anonymousAuth) {
        "W-39,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인: 취약
익명 인증이 활성화되어 있어 취약합니다. 필요하지 않다면 비활성화해 주세요.
"@
    } Else {
        "W-39,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인: 안전
익명 인증이 비활성화되어 있어 안전합니다.
"@
    }
} Else {
