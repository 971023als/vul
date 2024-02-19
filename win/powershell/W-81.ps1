# 관리자 권한 확인 및 스크립트 초기 설정
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "$PSCommandPath", "-Verb", "RunAs"
    exit
}

$computerName = $env:COMPUTERNAME
$resultDir = "C:\Window_${computerName}_result"

# 최대 암호 나이(MaximumPasswordAge) 설정 확인
$securityPolicy = secedit /export /cfg "$env:TEMP\secpol.cfg" 2>$null
$secpolContent = Get-Content "$env:TEMP\secpol.cfg"
$maximumPasswordAge = $secpolContent | Where-Object { $_ -match "MaximumPasswordAge\s*=\s*(\d+)" }

If ($matches[1] -lt 90) {
    $message = "W-81: 암호 최대 사용 기간이 90일 미만으로 설정됨. 설정값: $($matches[1])"
    "$message" | Out-File "$resultDir\W-81-${computerName}-result.txt"
} Else {
    $message = "W-81: 암호 최대 사용 기간이 90일 이상으로 설정되어 있지 않음. 설정값: $($matches[1])"
    "$message" | Out-File "$resultDir\W-81-${computerName}-result.txt"
}

# 결과 요약 및 보고
# 결과 파일을 이메일로 보내는 코드를 추가할 수 있습니다. (Send-MailMessage cmdlet 사용)
# Send-MailMessage -From "sender@example.com" -To "receiver@example.com" -Subject "Security Audit Summary" -Body (Get-Content $summaryPath -Raw) -SmtpServer "smtp.example.com"

# 스크립트 종료 전 임시 파일 삭제
Remove-Item "$env:TEMP\secpol.cfg" -Force

Write-Host "스크립트 실행 완료"
