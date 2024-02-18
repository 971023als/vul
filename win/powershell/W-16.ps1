# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $script = "-File `"" + $MyInvocation.MyCommand.Definition + "`""
    Start-Process PowerShell.exe -ArgumentList $script -Verb RunAs
    Exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.BackgroundColor = "DarkGreen"

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
fsutil file createnew "$rawDir\compare.txt" 0 | Out-Null
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content -Path "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Line >> "$rawDir\iis_path1.txt"
}

# 비밀번호 정책 분석
$localSecurityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$passwordHistorySize = ($localSecurityPolicy | Where-Object { $_ -match "PasswordHistorySize" }).Split("=")[1].Trim()

If ($passwordHistorySize -gt 11) {
    "W-16,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "준수 확인됨: 비밀번호 이력 크기가 11개 이전 비밀번호를 초과하도록 설정됨." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} Else {
    "W-16,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "준수하지 않음 감지됨: 비밀번호 이력 크기가 11개 이전 비밀번호를 초과하지 않음." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}
$localSecurityPolicy | Where-Object { $_ -match "PasswordHistorySize" } | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append

# 데이터 캡처
$localSecurityPolicy | Where-Object { $_ -match "PasswordHistorySize" } | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
