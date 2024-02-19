# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# 설정 및 초기화
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir | Out-Null

# 로컬 보안 정책 내보내기
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"

# 시스템 정보 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfigPath = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig = Get-Content $applicationHostConfigPath
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"

# 사용자 홈 디렉토리 권한 검사
$users = Get-ChildItem C:\Users -Directory | Where-Object { $_.Name -notmatch '^(All|Default|Public|.*\.)$' }
foreach ($user in $users) {
    $acl = Get-Acl "C:\Users\$($user.Name)"
    If ($acl.Access | Where-Object { $_.FileSystemRights -eq "FullControl" -and $_.IdentityReference -eq "Everyone" }) {
        "W-76,O,| 취약: Everyone 그룹에 대한 전체 권한이 설정되어 있습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt"
    } Else {
        "W-76,X,| 안전: Everyone 그룹에 대한 전체 권한이 설정되지 않았습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt"
    }
}

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 이메일로 결과 요약 보내기 (실제 작동하지 않음, 환경에 맞게 수정 필요)

# 정리 작업
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트가 완료되었습니다."
