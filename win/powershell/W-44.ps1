# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    exit
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

# W-44 RDP 최소 암호화 수준 검사 시작
Write-Host "------------------------------------------W-44 RDP 최소 암호화 수준 검사 시작------------------------------------------"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$minEncryptionLevel = (Get-ItemProperty -Path $regPath -Name "MinEncryptionLevel").MinEncryptionLevel

if ($minEncryptionLevel -gt 1) {
    "W-44,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "RDP 최소 암호화 수준이 적절히 설정되어 있습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    (Get-ItemProperty -Path $regPath -Name "MinEncryptionLevel") | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-44,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "RDP 최소 암호화 수준이 낮게 설정되어 있어 보안에 취약할 수 있습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    (Get-ItemProperty -Path $regPath -Name "MinEncryptionLevel") | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
}
Write-Host "-------------------------------------------W-44 RDP 최소 암호화 수준 검사 종료------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
