# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $script = "-File `"" + $MyInvocation.MyCommand.Definition + "`""
    Start-Process PowerShell.exe -ArgumentList $script -Verb RunAs
    Exit
}

# 콘솔 환경 설정 및 초기 설정
chcp 437 | Out-Null
$host.UI.RawUI.ForegroundColor = "Green"

$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# W-20 공유 설정 보안 검사
$shares = net share | Where-Object { $_ -notmatch "IPC\$" -and $_ -notmatch "ADMIN" -and $_ -notmatch "PRINT\$" -and $_ -notmatch "FAX\$" -and $_ -match "\$" }
$autoShareServer = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters" -Name "AutoShareServer"

If ($shares -and $autoShareServer.AutoShareServer -eq 0) {
    "W-20,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "문제 발견: AutoShareServer가 0이면 기본 공유가 생성되지 않는 문제를 해결" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    $shares | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} ElseIf ($autoShareServer.AutoShareServer -eq 0) {
    "W-20,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "문제 없음: AutoShareServer가 0이면 기본 공유가 생성되지 않아 보안 강화" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} Else {
    "W-20,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "문제 발견: AutoShareServer가 0이 아니면 기본 공유가 생성될 위험" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}

# W-20 데이터 캡처
$shares | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
