# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-NoProfile", "-ExecutionPolicy Bypass", "-File", "`"$PSCommandPath`"", "$args"
    Start-Process "PowerShell" -Verb RunAs -ArgumentList $arguments
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
$line = Get-Content "$rawDir\iis_path1.txt" -Raw
$line | Out-File -FilePath "$rawDir\line.txt"

1..5 | ForEach-Object {
    $filePath = "$rawDir\path$_.txt"
    Get-Content "$rawDir\line.txt" | ForEach-Object {
        If ($_ -match ".*\*$_.*") {
            $_ | Out-File -FilePath $filePath -Append
        }
    }
}

# MetaBase.xml 추가 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Host "------------------------------------------설정 종료-------------------------------------------"

Write-Host "------------------------------------------W-38 점검 시작------------------------------------------"
If (Test-Path "$rawDir\FTP_PATH.txt") {
    Get-Content "$rawDir\FTP_PATH.txt" | ForEach-Object {
        $acl = Get-Acl $_
        $acl | Out-File "$rawDir\w-38-1.txt"
        If ($acl.Access | Where-Object { $_.FileSystemRights -like "*FullControl*" -and $_.IdentityReference -like "*Everyone*" }) {
            "W-38,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
            @"
상태 확인
FTP 권한 설정에서 EVERYONE 그룹에 대한 접근 권한이 발견되어 취약합니다
조치 방안
EVERYONE 그룹의 접근 권한을 제거하십시오
"@
        } Else {
            "W-38,안전,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
            @"
상태 확인
FTP
