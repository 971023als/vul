# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    $script = $MyInvocation.MyCommand.Definition
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", $script -Verb RunAs
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
mkdir $rawDir, $resultDir | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
fsutil file createnew "$rawDir\compare.txt" 0 | Out-Null
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# "LimitBlankPasswordUse" 보안 정책 감사
$localSecurityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$limitBlankPasswordUsePolicy = $localSecurityPolicy | Where-Object { $_ -match "LimitBlankPasswordUse" }

if ($limitBlankPasswordUsePolicy -match "1") {
    "W-17,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "준수 확인됨: LimitBlankPasswordUse 정책이 올바르게 적용됨." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-17,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "준수하지 않음 감지됨: LimitBlankPasswordUse 정책이 올바르게 적용되지 않음." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}
$limitBlankPasswordUsePolicy | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append

# 데이터 캡처
$limitBlankPasswordUsePolicy | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
