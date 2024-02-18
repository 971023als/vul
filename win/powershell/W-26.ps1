# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process PowerShell -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$PSCommandPath`"", "-Verb RunAs"
    exit
}

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
$null = New-Item -Path "$rawDir\compare.txt" -ItemType File
Set-Location -Path $rawDir
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# W-26 취약한 디렉토리 검사
$serviceRunning = Get-Service W3SVC -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Running' }
$vulnerableDirs = @("c:\program files\common files\system\msadc\sample", "c:\winnt\help\iishelp", "c:\inetpub\iissamples", "${env:SystemRoot}\System32\Inetsrv\IISADMPWD")
$result = foreach ($dir in $vulnerableDirs) {
    if (Test-Path $dir) { $dir }
}

if ($serviceRunning -and $result) {
    "W-26,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "정책 위반" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    $result | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} elseif ($serviceRunning) {
    "W-26,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "IIS 서비스가 실행되지 않아 정책 준수" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} else {
    "W-26,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "정책 준수 (IIS 서비스 미사용)" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}

# 결과 데이터 캡처
$result | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
