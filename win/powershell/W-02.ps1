# 관리자 권한 확인 및 요청
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 콘솔 환경 설정
$OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
$host.UI.RawUI.BackgroundColor = 'Green'
$host.UI.RawUI.ForegroundColor = 'Black'
Clear-Host

# 기본 디렉토리 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory -Force | Out-Null

# 로컬 보안 정책 내보내기 및 기본 파일 생성
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File

# 설치 경로 및 시스템 정보 수집
Set-Location -Path $rawDir
[System.IO.File]::WriteAllText("$rawDir\install_path.txt", (Get-Location).Path)
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 수집
$applicationHostConfig = Get-Content -Path $env:WinDir\System32\Inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"

# 게스트 계정 상태 확인
$guestAccountInfo = net user guest
$isActive = $guestAccountInfo -match "Account active\s+Yes"

if ($isActive) {
    "W-02,X,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "위반 상태`n게스트 계정이 활성화 되어 있는 위험 상태`n조치 필요`n게스트 계정을 비활성화 하십시오`n위반 내용`n게스트 계정이 활성화 상태로 남아있어 조치가 필요합니다|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-02,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "정상 상태`n게스트 계정이 비활성화 되어 있는 상태`n조치 방안`n게스트 계정이 정상적으로 비활성화 되어 있습니다`n정상 처리`n게스트 계정이 비활성화 상태로 유지되고 있으므로 안전합니다|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
}

# Raw data 기록
"--------------------------------------W-02---------------------------------------" | Out-File -FilePath "$resultDir\W-Window-$computerName-rawdata.txt" -Append
$guestAccountInfo | Out-File -FilePath "$resultDir\W-Window-$computerName-rawdata.txt" -Append
"--------------------------------------------------------------------------------" | Out-File -FilePath "$resultDir\W-Window-$computerName-rawdata.txt" -Append
