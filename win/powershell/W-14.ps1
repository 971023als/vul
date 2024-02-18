# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "$PSCommandPath", "-Verb", "RunAs"
    exit
}

# 콘솔 환경 설정
chcp 437 | Out-Null
$host.UI.RawUI.ForegroundColor = "Green"

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File | Out-Null
Set-Location -Path $rawDir
(Get-Location).Path | Out-File -FilePath "install_path.txt"
systeminfo | Out-File -FilePath "systeminfo.txt"

# IIS 설정 분석
Copy-Item -Path "${env:WinDir}\System32\Inetsrv\Config\applicationHost.Config" -Destination "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File -FilePath "$rawDir\iis_path1.txt"

# 보안 정책 감사 - SeInteractiveLogonRight
$securityPolicy = Get-Content -Path "$rawDir\Local_Security_Policy.txt"
$interactiveLogonRight = Select-String -Path "$rawDir\Local_Security_Policy.txt" -Pattern "SeInteractiveLogonRight"

"------------------------------------------W-14 Security Policy Audit------------------------------------------" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
"Checking policy" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
"The interactive logon right policy check for Administrators, IUSR accounts" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
"Policy details" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
$interactiveLogonRight | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
"Conclusion: If necessary, adjust the policy to ensure compliance." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append

# 데이터 캡처
$interactiveLogonRight | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
