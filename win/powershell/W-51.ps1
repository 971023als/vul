# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File `"$PSCommandPath`"' -Verb RunAs"
    exit
}

# 콘솔 환경 설정
chcp 437 > $null
$Host.UI.RawUI.BackgroundColor = "DarkGreen"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# 기본 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_$($computerName)_raw"
$resultDir = "C:\Window_$($computerName)_result"

# 디렉터리 준비
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDir, $resultDir -Force | Out-Null

# 시스템 정보 수집
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 정보 수집
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"

# Telnet 서비스 보안 설정 검사
Write-Host "------------------------------------------Telnet Service Security Setting------------------------------------------"
$telnetRegistryPath = "HKLM\Software\Microsoft\TelnetServer"
$telnetServiceStatus = Get-Service -Name TlntSvr -ErrorAction SilentlyContinue

If ($telnetServiceStatus -and $telnetServiceStatus.Status -eq 'Running') {
    Try {
        $telnetConfig = & tlntadmn config
        $authenticationMethod = $telnetConfig | Where-Object {$_ -match "Authentication"}

        If ($authenticationMethod -match "NTLM" -and $authenticationMethod -notmatch "Password") {
            "W-51,O,| Telnet service is using secure NTLM authentication method." | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
        } Else {
            "W-51,X,| Telnet service is using insecure authentication method, recommend to use NTLM and avoid passwords." | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
        }
    } Catch {
        "W-51,Error,| Failed to retrieve Telnet service configuration." | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
    }
} Else {
    "W-51,O,| Telnet service is not running or not installed, which is considered secure." | Out-File "$resultDir\W-Window-$($computerName)-result.txt" -Append
}

Write-Host "------------------------------------------End of Telnet Service Security Setting------------------------------------------"

# 결과 요약
Get-Content "$resultDir\W-Window-*" | Out-File "$resultDir\security_audit_summary.txt"

# 정리 작업
Remove-Item -Path $rawDir\* -Force

Write-Host "Script has completed. Results have been saved to $resultDir\security_audit_summary.txt."
