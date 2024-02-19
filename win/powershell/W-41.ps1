# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    $script = "-File `"$(Get-Location)\$($MyInvocation.MyCommand.Name)`" $args"
    Start-Process PowerShell -ArgumentList $script -Verb RunAs
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

# 로컬 보안 정책 내보내기 및 비교 파일 생성
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null

# DNS 보안 설정 점검 시작
Write-Host "------------------------------------------W-41 DNS 보안 설정 점검 시작------------------------------------------"
$dnsService = Get-Service "DNS" -ErrorAction SilentlyContinue
if ($dnsService.Status -eq "Running") {
    $dnsZonesRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones"
    $secureSecondaries = Get-ItemProperty -Path $dnsZonesRegPath -Name "SecureSecondaries" -ErrorAction SilentlyContinue | Where-Object { $_.SecureSecondaries -eq 2 }

    if ($secureSecondaries) {
        "W-41,안전,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인: 안전
DNS 전송 설정이 안전하게 구성되어 있습니다.
"@
    } else {
        "W-41,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
상태 확인: 취약
DNS 전송 설정이 취약한 구성으로 되어 있습니다.
조치 방안: DNS 전송 설정을 보안 강화를 위해 수정해야 합니다.
"@
    }
} else {
    "W-41,정보,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
상태 확인: DNS 서비스 미설치 또는 비활성화
DNS 서비스가 실행 중이지 않습니다.
"@
}
Write-Host "-------------------------------------------W-41 DNS 보안 설정 점검 종료------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_%COMPUTERNAME%_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
