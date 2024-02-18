# 관리자 권한 확인
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "관리자 권한이 필요합니다..."
    Start-Process PowerShell -ArgumentList "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs" -Verb RunAs
    Exit
}

# 기본 설정
$computerName = $env:COMPUTERNAME
$rawPath = "C:\Window_${computerName}_raw"
$resultPath = "C:\Window_${computerName}_result"

Remove-Item -Path $rawPath -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $resultPath -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawPath -ItemType Directory -Force
New-Item -Path $resultPath -ItemType Directory -Force

# 로컬 보안 정책 내보내기
secedit /EXPORT /CFG "$rawPath\Local_Security_Policy.txt"

# 시스템 정보 수집
systeminfo | Out-File -FilePath "$rawPath\systeminfo.txt"

# IIS 설정 수집
$applicationHostConfig = Get-Content -Path $env:WinDir\System32\Inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File -FilePath "$rawPath\iis_setting.txt"

# 추가적인 처리와 검사 로직은 여기에 구현합니다...

# 예를 들어, 관리자 계정 이름 변경 여부 확인
$adminNameChange = Select-String -Path "$rawPath\Local_Security_Policy.txt" -Pattern "NewAdministratorName"
If ($adminNameChange -ne $null) {
    # 위반 사항 기록 로직
} Else {
    # 정상 사항 기록 로직
}

# 위의 예제는 스크립트의 일부분만을 PowerShell로 변환한 것입니다. 전체 스크립트를 변환하려면 각 단계와 명령어를 PowerShell의 문법과 기능에 맞게 조정해야 합니다.
