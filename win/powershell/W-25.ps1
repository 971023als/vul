# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (-not $isAdmin) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "`"$PSCommandPath`"", "-Verb", "RunAs"
    exit
}

# 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.ForegroundColor = "Green"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_$($computerName)_raw"
$resultDir = "C:\Window_$($computerName)_result"

# 초기 설정
Remove-Item $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
$null = New-Item -Path "$rawDir\compare.txt" -ItemType File
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
$applicationHostConfig | Select-String -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Line >> "$rawDir\iis_path1.txt"
}

# W-25 부모 경로 사용 설정 확인
$serviceRunning = Get-Service W3SVC -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Running' }
if ($serviceRunning) {
    $enableParentPaths = Select-String -Path "$rawDir\iis_setting.txt" -Pattern "asp enableParentPaths" 
    if ($enableParentPaths) {
        "W-25,X,|" | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
        "부모 경로 사용 설정이 활성화되어 있어 보안 위반" | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
    } else {
        "W-25,O,|" | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
        "부모 경로 사용 설정이 비활성화되어 있어 보안 준수" | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
    }
} else {
    "W-25,O,|" | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
    "IIS 서비스가 실행되지 않아 보안 준수" | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
}

# 결과 데이터 캡처
"$env:WinDir\System32\Inetsrv\Config\applicationHost.Config" | Get-Content | Select-String -Pattern "enableParentPaths" | Out-File "$resultDir\W-Window-$($computerName)-rawdata.txt" -Append
