# 관리자 권한 요청
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "$PSCommandPath", "-Verb", "RunAs"
    exit
}

# 콘솔 환경 설정 및 초기 설정
chcp 437 | Out-Null
$host.UI.RawUI.ForegroundColor = "Green"

$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
mkdir $rawDir, $resultDir | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Value $null
(Get-Location).Path | Out-File "$rawDir\install_path.txt"
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
$applicationHostConfig = Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"

# W-19 공유 폴더 접근 권한 분석
$shareInfo = net share | Where-Object { $_ -notmatch "\$$" -and $_ -notmatch "command" -and $_ -notmatch "-" }
$shareInfo | Out-File "$rawDir\W-19.txt"
$permissionDetails = @()
foreach ($line in $shareInfo) {
    $tokens = $line -split "\s+"
    if ($tokens.Count -gt 1) {
        $sharePath = $tokens[1]
        $acl = cacls $sharePath
        $acl | Out-File "$rawDir\W-19-1.txt" -Append
        $permissionDetails += $acl
    }
}

$everyoneAccess = Select-String -Path "$rawDir\W-19-1.txt" -Pattern "Everyone"
if ($everyoneAccess) {
    "W-19,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "문제 발견: 공유 폴더 설정을 점검하거나 필요한 폴더만 공유하며, 공유 설정에서 Everyone 그룹의 접근을 제한하세요." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    $permissionDetails | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
} else {
    "W-19,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "문제 없음: 공유 폴더 보안 설정이 적절하며, Everyone 그룹의 접근이 제한되어 있습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# W-19 데이터 캡처
$shareInfo | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
$permissionDetails | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
