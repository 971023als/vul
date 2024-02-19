# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
If (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "`"$PSCommandPath`"", "-Verb", "RunAs"
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

Set-Location -Path $rawDir

# IIS 설정 분석
Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config" | Out-File -FilePath "$rawDir\iis_setting.txt"
Get-Content "$rawDir\iis_setting.txt" | Select-String "physicalPath|bindingInformation" | Out-File -FilePath "$rawDir\iis_path1.txt"

# MetaBase.xml 분석 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Host "------------------------------------------설정 종료-------------------------------------------"

# W-40 점검 시작
Write-Host "------------------------------------------W-40 점검 시작------------------------------------------"
If (Test-Path "$rawDir\ftp_path.txt") {
    $metaBaseContent = Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml"
    $ipSecurity = $metaBaseContent | Where-Object { $_ -match "IIsFtpService" -and $_ -match "IIsFtpVirtualDir" -and $_ -match 'IPSecurity="0102"' }

    If ($ipSecurity) {
        "W-40,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인: 안전
특정 IP 주소에서만 FTP 접속이 허용되어 있습니다.
"@
    } Else {
        "W-40,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인: 취약
특정 IP 주소에서만 FTP 접속이 허용되어야 하나, 현재 모든 IP에서 접속이 허용되어 있어 취약합니다.
조치 방안: 필요한 IP 주소만 접속을 허용하도록 설정 변경이 필요합니다.
"@
    }
} Else {
    "W-40,정보,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
상태 확인: FTP 서비스 미설치 또는 비활성화
FTP 경로 파일을 찾을 수 없습니다. FTP 서비스가 설치되어 있지 않거나 비활성화되어 있을 수 있습니다.
"@
}
Write-Host "-------------------------------------------W-40 점검 종료
