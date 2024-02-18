# 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File", "$PSCommandPath", "-Verb", "RunAs"
    Exit
}

# 콘솔 환경 설정 및 초기 설정
chcp 949 | Out-Null
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

# W-24 폴더 권한 검사
$serviceStatus = Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue
$foldersToCheck = @("C:\inetpub\scripts", "C:\inetpub\cgi-bin")
$reportPath = "$rawDir\W-24.txt"
$hasPermissionIssue = $false

If ($serviceStatus.Status -eq "Running") {
    Foreach ($folder in $foldersToCheck) {
        If (Test-Path $folder) {
            $acl = Get-Acl $folder
            $acl.Access | Where-Object { $_.FileSystemRights -match "Write|Modify|FullControl" -and $_.IdentityReference -eq "Everyone" } | ForEach-Object {
                $hasPermissionIssue = $true
                "$folder has write/modify/full control permission for Everyone" | Out-File -FilePath $reportPath -Append
            }
        }
    }
    If ($hasPermissionIssue) {
        "W-24,X,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
        "정책 위반: cgi-bin, scripts 폴더에 Everyone 그룹에게 부여된 쓰기, 삭제, 실행 권한이 있어 보안 위반" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    } Else {
        "W-24,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
        "정책 준수: cgi-bin, scripts 폴더에 Everyone 그룹에게 부여된, 쓰기, 삭제, 실행 권한 없음으로 보안 준수" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    }
} Else {
    "W-24,O,|" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
    "정책 준수: IIS 서비스가 필요하지 않아 비활성화된 상태로 보안 준수" | Out-File "$resultDir\W-Window-${computerName}-result.txt" -Append
}

# W-24 데이터 캡처
If (Test-Path $reportPath) {
