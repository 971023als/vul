# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "$PSCommandPath", "-Verb", "RunAs"
    Exit
}

# 콘솔 환경 설정 및 초기 설정
chcp 437 | Out-Null
$host.UI.RawUI.ForegroundColor = "Green"

$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
$null = New-Item -Path "$rawDir\compare.txt" -ItemType File
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfigPath = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig = Get-Content $applicationHostConfigPath
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Matches.Value >> "$rawDir\iis_path1.txt"
}

# W-23 디렉토리 브라우징 체크
$serviceStatus = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
If ($serviceStatus.Status -eq "Running") {
    $iisPaths = Get-Content "$rawDir\http_path.txt"
    Foreach ($path in $iisPaths) {
        If (Test-Path $path\web.config) {
            $webConfig = Get-Content "$path\web.config"
            If ($webConfig -match "<directoryBrowse .*enabled=`"true`"") {
                "W-23,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
                "불안전한 상태: 디렉토리 브라우징이 활성화되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
                Break
            }
        }
    }
    If (!$?) {
        "W-23,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
        "안전한 상태: 디렉토리 브라우징이 비활성화되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    }
} Else {
    "W-23,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "안전한 상태: World Wide Web Publishing Service가 실행되지 않고 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}

# W-23 데이터 캡처
Get-Content "$rawDir\W-23.txt" | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
