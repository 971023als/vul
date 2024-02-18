# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "관리자 권한이 필요합니다..."
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# 초기 환경 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
$securityPolicy = secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null

# 시스템 정보 수집
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

# IIS 설정 수집
$applicationHostConfig = Get-Content -Path "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
Get-Content -Path "$env:WinDir\System32\inetsrv\MetaBase.xml" | Out-File -FilePath "$rawDir\iis_setting.txt" -Append

# 계정 잠금 임계값 검사
$accountPolicies = secedit /export /areas SECURITYPOLICY /cfg "$rawDir\secconfig.cfg"
$lockoutThreshold = (Get-Content "$rawDir\secconfig.cfg" | Select-String "LockoutBadCount").ToString().Split('=')[1].Trim()

If ($lockoutThreshold -gt 5) {
    $resultText = "W-04,X,| 준수하지 않음이 감지되었습니다. 계정 잠금 임계값이 5회 시도보다 많게 설정되어 있으며, 이는 준수되지 않습니다."
} ElseIf ($lockoutThreshold -eq 0) {
    $resultText = "W-04,X,| 준수하지 않음이 감지되었습니다. 계정 잠금 임계값이 설정되지 않았습니다(없음), 이는 준수되지 않습니다."
} Else {
    $resultText = "W-04,O,| 준수됨이 감지되었습니다. 계정 잠금 임계값이 준수 범위 내에 설정되었습니다."
}

# 결과 기록
$resultText | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt"
"잠금 임계값: $lockoutThreshold" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append

# 원시 데이터 기록
"net accounts" | Out-File -FilePath "$resultDir\W-Window-$computerName-rawdata.txt" -Append
