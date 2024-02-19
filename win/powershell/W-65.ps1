# 관리자 권한 확인 및 요청
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $windowsPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "$PSCommandPath" -Verb RunAs
    exit
}

# 환경 변수 설정
$computerName = $env:COMPUTERNAME
$resultDir = "C:\Window_${computerName}_result"
$resultFile = Join-Path $resultDir "W-Window-$computerName-result.txt"

# 결과 디렉터리 생성
if (Test-Path $resultDir) {
    Remove-Item -Path $resultDir -Recurse
}
New-Item -ItemType Directory -Path $resultDir | Out-Null

# "로그온 없이 시스템 종료" 정책 확인
$shutdownWithoutLogon = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").ShutdownWithoutLogon

# 결과 기록
if ($shutdownWithoutLogon -eq 0) {
    $status = "O"
    $message = "취약: '로그온 없이 시스템을 종료할 수 있는 정책'이 비활성화되어 있습니다."
} else {
    $status = "X"
    $message = "안전: '로그온 없이 시스템을 종료할 수 있는 정책'이 활성화되어 있습니다."
}

# 결과 파일에 기록
"$status,|$message" | Out-File -FilePath $resultFile

# 결과 요약 보고
Write-Host "결과가 $resultDir에 저장되었습니다."

# 스크립트 종료 메시지
Write-Host "스크립트를 종료합니다."
