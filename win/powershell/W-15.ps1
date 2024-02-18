# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $currentScript = $MyInvocation.MyCommand.Definition
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $currentScript -Verb RunAs
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
mkdir $rawDir, $resultDir | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
fsutil file createnew "$rawDir\compare.txt" 0 | Out-Null
$installPath = Get-Location
$installPath.Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content -Path "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# LSA 익명 이름 조회 설정의 보안 정책 감사
$securityPolicyContent = Get-Content "$rawDir\Local_Security_Policy.txt"
$LSAAnonymousNameLookup = $securityPolicyContent | Where-Object { $_ -match "LSAAnonymousNameLookup" }

If ($LSAAnonymousNameLookup -match "0") {
    "W-15,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "준수 상태 감지됨: LSA 익명 이름 조회가 올바르게 비활성화되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
} Else {
    "W-15,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "비준수 상태 감지됨: LSA 익명 이름 조회가 활성화되어 있습니다." | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}
$LSAAnonymousNameLookup | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append

# 원본 데이터 캡처
$LSAAnonymousNameLookup | Out-File "$resultDir\W-Window-${computerName}-rawdata.txt" -Append
