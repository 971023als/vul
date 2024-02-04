# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 환경 설정
$computerName = $env:COMPUTERNAME
$rawFolder = "C:\Window_${computerName}_raw"
$resultFolder = "C:\Window_${computerName}_result"

Remove-Item -Path $rawFolder -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $resultFolder -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawFolder -ItemType Directory
New-Item -Path $resultFolder -ItemType Directory
Remove-Item -Path "$resultFolder\W-Window-*.txt" -ErrorAction SilentlyContinue

# 보안 정책 내보내기
secedit /EXPORT /CFG "$rawFolder\Local_Security_Policy.txt"

# 비교 파일 생성
New-Item -Path "$rawFolder\compare.txt" -ItemType File

# 설치 경로 저장
$installPath = (Get-Location).Path
$installPath | Out-File "$rawFolder\install_path.txt"

# 시스템 정보 조회
systeminfo | Out-File "$rawFolder\systeminfo.txt"

# IIS 설정 검토
$applicationHostConfig = Get-Content -Path $env:WinDir\System32\Inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File "$rawFolder\iis_setting.txt"

# 공유폴더 및 권한 확인
$shares = net share | Out-File "$env:TEMP\shares.txt"
$shareCheck = Get-Content -Path "$env:TEMP\shares.txt" | Where-Object {$_ -notmatch "C\$|IPC\$|ADMIN\$"} | ForEach-Object {
    $shareName, $sharePath = $_ -split '\s+', 2
    $acl = icacls $sharePath
    if ($acl -match "Everyone") {
        Write-Output "취약한 공유폴더 발견: $shareName - Everyone 권한이 감지되었습니다."
    } else {
        Write-Output "$shareName - Everyone 권한이 없습니다. 양호합니다."
    }
}

# SMTP 서비스 실행 여부 확인
"불필요한 SMTP 서비스 실행 여부를 확인합니다..." | Out-File "$resultFolder\W-Window-$computerName-rawdata.txt"
Get-Service smtp | Out-File "$resultFolder\W-Window-$computerName-rawdata.txt" -Append

Write-Host "스크립트 실행이 완료되었습니다."
