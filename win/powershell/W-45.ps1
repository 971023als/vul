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

# W-45 IIS 커스텀 에러 페이지 설정 검사 시작
Write-Host "------------------------------------------W-45 IIS 커스텀 에러 페이지 설정 검사 시작------------------------------------------"
$webService = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
if ($webService.Status -eq "Running") {
    $httpPath = Get-Content "$rawDir\http_path.txt"
    $webConfigContent = Get-Content (Join-Path $httpPath "web.config")
    $webConfigContent | Out-File "$rawDir\W-45.txt"
    
    $errorStatusCodes = Select-String -Path "$rawDir\W-45.txt" -Pattern "error statusCode"
    $custErrPath = Select-String -Path "$rawDir\iis_setting.txt" -Pattern "%SystemDrive%\inetpub\custerr\"

    if ($errorStatusCodes -and $custErrPath) {
        "W-45,경고,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        @"
커스텀 에러 페이지 설정이 적절하지 않아 보안에 취약할 수 있습니다.
"@
        $errorStatusCodes, $custErrPath | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-45,OK,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        "커스텀 에러 페이지 설정이 적절하게 구성되어 보안이 강화되었습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-45,정보,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "World Wide Web Publishing Service가 실행되지 않고 있습니다. IIS 설정이 필요 없을 수 있습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
}
Write-Host "-------------------------------------------W-45 IIS 커스텀 에러 페이지 설정 검사 종료------------------------------------------"

# 결과 요약
Write-Host "결과가 C:\Window_$computerName\_result\security_audit_summary.txt에 저장되었습니다."
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
