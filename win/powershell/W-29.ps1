# 관리자 권한 요청
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory

# 로컬 보안 정책 내보내기
secedit /export /cfg "$rawDir\Local_Security_Policy.txt" | Out-Null
New-Item -Path "$rawDir\compare.txt" -ItemType File

# 시스템 정보 저장
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
(Get-Content "$rawDir\iis_path1.txt" -Raw) | Out-File "$rawDir\line.txt"

1..5 | ForEach-Object {
    $pathNumber = $_
    (Get-Content "$rawDir\line.txt" -Raw) -split '\*' | Select-Object -Index ($pathNumber - 1) | Out-File "$rawDir\path$pathNumber.txt"
}

Get-Content "$env:WINDOWS\system32\inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt"

# W-29 분석 시작
# PowerShell 스크립트에서 W-29 관련 분석을 추가합니다.
# 예를 들어, 특정 조건을 확인하고 결과를 파일에 저장하는 코드를 여기에 추가할 수 있습니다.

# 분석 결과 출력
"결과 파일 경로: $resultDir\W-Window-$computerName-result.txt" | Out-File "$resultDir\W-Window-$computerName-result.txt"
