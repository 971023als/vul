# 관리자 권한으로 스크립트 실행 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $PSCommandPath, "-Verb RunAs"
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
$installPath = Get-Location
$installPath.Path | Out-File -FilePath "$rawDir\install_path.txt"

# 시스템 정보 저장
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Host "------------------------------------------IIS Setting-----------------------------------"
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$bindingInfo = Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation"
$line = $bindingInfo -join ""
$line | Out-File -FilePath "$rawDir\line.txt"

1..5 | ForEach-Object {
    $filePath = "$rawDir\path$_.txt"
    $bindingInfo | ForEach-Object {
        If ($_ -match ".*\*$_.*") {
            $matches[0] | Out-File -FilePath $filePath -Append
        }
    }
}

# MetaBase.xml 추가 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Host "------------------------------------------end-------------------------------------------"

# IIS 설정 기반 보안 검사
Write-Host "------------------------------------------W-33------------------------------------------"
$serviceStatus = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
If ($serviceStatus.Status -eq "Running") {
    $iisSettings = Get-Content "$rawDir\iis_setting.txt"
    $unsupportedExtensions = ".htr", ".idc", ".stm", ".shtm", ".shtml", ".printer", ".htw", ".ida", ".idq"
    $foundExtensions = $iisSettings | Where-Object { $_ -match ($unsupportedExtensions -join "|") }
    $foundExtensions | Out-File "$rawDir\W-33.txt"

    If ((Get-Content "$rawDir\W-33.txt").Length -gt 0) {
        "W-33,X,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        "테스트
지원되지 않는 파일 확장자 발견
지원되지 않는 `.htr .idc .stm .shtm .shtml .printer .htw .ida .idq` 파일 확장자로 인해 보안이 위협됨
|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    } Else {
        "W-33,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        "테스트
지원되지 않는 `.htr .idc .stm .shtm .shtml .printer .htw .ida .idq` 파일 확장자가 존재하지 않아 안전
|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} Else {
    "W-33,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    "테스트
IIS 서비스가 필요하지 않아 사용되지 않는 상태 보안
IIS 서비스가 활성화 되었으나 필요하지 않으므로 보안임
|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
}

Write-Host "-------------------------------------------end------------------------------------------"

# 결과 요약 보고
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"
Write-Host "결과가 $resultDir\security_audit_summary.txt 에 저장되었습니다."

# 정리 작업
Write-Host "정리 작업을 수행합니다..."
Remove-Item "$rawDir\*" -Force

Write-Host "스크립트를 종료합니다."
