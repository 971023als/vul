# 관리자 권한 확인 및 요청
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 시스템 설정 변경
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(437)
Write-Host "------------------------------------------설정---------------------------------------"

$computerName = $env:COMPUTERNAME
$rawPath = "C:\Window_${computerName}_raw"
$resultPath = "C:\Window_${computerName}_result"

# 기존 폴더 및 파일 제거 및 새 폴더 생성
Remove-Item -Path $rawPath, $resultPath -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawPath, $resultPath -ItemType Directory | Out-Null

# 보안 정책, 시스템 정보 등 수집
secedit /export /cfg "$rawPath\Local_Security_Policy.txt"
New-Item -Path "$rawPath\compare.txt" -ItemType File -Force
Get-Location > "$rawPath\install_path.txt"
$installPath = Get-Content "$rawPath\install_path.txt" -Raw
systeminfo > "$rawPath\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = Get-Content "$env:WINDIR\System32\inetsrv\config\applicationHost.Config"
$applicationHostConfig > "$rawPath\iis_setting.txt"

# 사용자 계정 정보 수집
$users = net user | Where-Object {$_ -notmatch "명령을" -and $_ -trim -ne ""} | ForEach-Object {$_ -replace "\s+", " "} | Out-String
$users > "$rawPath\user.txt"

$activeUsers = @()
Get-Content "$rawPath\user.txt" | ForEach-Object {
    $userInfo = net user $_.Trim()
    if ($userInfo -match "계정 활성 상태\s+.*Yes") {
        $activeUsers += $_.Trim()
        "$userInfo" > "$rawPath\user_info.txt"
    }
}

# 조건에 따른 결과 처리
# 예: 사용자 'test'와 'guest'의 계정 상태 검사
$testOrGuestExists = $false
foreach ($user in $activeUsers) {
    if ($user -eq "test" -or $user -eq "guest") {
        $testOrGuestExists = $true
        break
    }
}

$resultFilePath = "$resultPath\W-Window-${computerName}-result.txt"
if ($testOrGuestExists) {
    "W-03,X,|" > $resultFilePath
    "위반 사항이 감지되었습니다" >> $resultFilePath
    # 추가 결과 기록...
} else {
    "W-03,C,|" > $resultFilePath
    "위반 사항이 없습니다" >> $resultFilePath
    # 추가 결과 기록...
}

# 이 코드는 기본적인 변환을 제공합니다. 모든 세부 사항과 예외 처리를 완전히 다루지는 않습니다.
# 실제 사용 전에 경로, 권한 설정, 실행 환경 등을 고려하여 테스트하고 필요에 따라 조정해야 합니다.
