# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{ 
    Start-Process PowerShell -ArgumentList "Start-Process PowerShell -ArgumentList '-File `"$PSCommandPath`"' -Verb RunAs" -Verb RunAs; 
    exit 
}

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory

# 로컬 보안 정책 내보내기 및 시스템 정보 저장
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfigPath = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$metaBaseXmlPath = "$env:WINDOWS\system32\inetsrv\MetaBase.xml"

Get-Content $applicationHostConfigPath | Out-File "$rawDir\iis_setting.txt"
(Get-Content $applicationHostConfigPath) -join "`n" | Select-String -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
(Get-Content "$rawDir\iis_path1.txt" -Raw) | Out-File "$rawDir\line.txt"
1..5 | ForEach-Object {
    Get-Content "$rawDir\line.txt" -Raw -split '\*' | Select-Object -Index ($_-1) | Out-File "$rawDir\path$_.txt"
}
Get-Content $metaBaseXmlPath | Out-File "$rawDir\iis_setting.txt"

# W-30 보안 검사 시작
if ((Get-Service W3SVC -ErrorAction SilentlyContinue).Status -eq 'Running') {
    $iisSettings = Get-Content "$rawDir\iis_setting.txt"
    $asaFiles = $iisSettings | Select-String -Pattern "\.asa" -AllMatches
    $asaxFiles = $iisSettings | Select-String -Pattern "\.asax" -AllMatches
    $allowedFalse = $iisSettings | Select-String -Pattern 'allowed="false"' -AllMatches

    if ($asaFiles -and $asaxFiles -and $allowedFalse) {
        "W-30,O,|.asa 및 .asax 파일이 안전하게 처리되어 있습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt"
    } else {
        "W-30,X,|.asa 및 .asax 파일 처리에 문제가 있습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt"
    }
} else {
    "W-30,O,|World Wide Web Publishing Service가 실행되지 않고 있습니다. IIS 구성 검사가 필요하지 않습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt"
}
# 보안 검사 완료

"결과 파일 경로: $resultDir\W-Window-$computerName-result.txt" | Out-Host
