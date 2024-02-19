# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb", "RunAs"
    Exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Host "------------------------------------------Setting---------------------------------------"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 이전 디렉토리 삭제 및 새 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null

# 로컬 보안 정책 내보내기 및 비교 파일 생성
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null

# 설치 경로 저장
$installPath = (Get-Location).Path
$installPath | Out-File -FilePath "$rawDir\install_path.txt"

# 시스템 정보 저장
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Host "------------------------------------------IIS Setting-----------------------------------"
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$bindingInfo = $applicationHostConfig | Select-String "physicalPath|bindingInformation"
$line = $bindingInfo -join "`n"
$line | Out-File -FilePath "$rawDir\line.txt"

1..5 | ForEach-Object {
    $filePath = "$rawDir\path$_.txt"
    $bindingInfo | ForEach-Object {
        If ($_ -match ".*\*$_.*") {
            $_.Matches.Value | Out-File -FilePath $filePath -Append
        }
    }
}

# MetaBase.xml 추가 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Host "------------------------------------------end-------------------------------------------"
Write-Host "------------------------------------------W-34------------------------------------------"

# World Wide Web Publishing Service 상태 확인
$serviceStatus = (Get-Service W3SVC -ErrorAction SilentlyContinue).Status
If ($serviceStatus -eq "Running") {
    "W-34,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
테스트
IIS 5.0 이하 버전에 해당하는 컴포넌트가 설치되지 않았거나 IIS 6.0 이상의 경우 보안
테스트 종료
해당 서버는 IIS 6.0 이상이므로 해당 항목 보안
테스트
해당 서버는 IIS 6.0 이상이므로 해당 항목 보안임
"@
} Else {
    "W-34,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    @"
테스트
IIS 서비스가 필요하지 않아 사용되지 않는 상태 보안
테스트 종료
IIS 서비스가 활성화되었음
테스트
IIS 서비스가 활성화되었으나 필요하지 않으므로 보안임
"@
}

Write-Host "-------------------------------------------end------------------------------------------"
Write-Host "------------------------------------------결과 요약------------------------------------------"

# 결과 요약 보고
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"
Write-Host "결과가 $resultDir\security_audit_summary.txt 에 저장되었습니다."

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
