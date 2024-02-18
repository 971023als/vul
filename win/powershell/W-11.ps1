# 관리자 권한이 없으면 관리자 권한으로 스크립트 재실행
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process PowerShell.exe -ArgumentList "-File", "`"$PSCommandPath`"", "-NoProfile", "-ExecutionPolicy Bypass" -Verb RunAs
    Exit
}

# 콘솔 환경 설정
chcp 437
$host.UI.RawUI.BackgroundColor = "DarkGreen"
Clear-Host

# 변수 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 디렉토리 초기화
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory -Force | Out-Null
Remove-Item -Path "${resultDir}\W-Window-*.txt" -ErrorAction SilentlyContinue

# 기본 정보 수집
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Force | Out-Null
(Get-Location).Path > "$rawDir\install_path.txt"
systeminfo > "$rawDir\systeminfo.txt"

# IIS 설정 파일 내용 복사
$applicationHostConfig = Get-Content -Path "${env:WinDir}\System32\Inetsrv\Config\applicationHost.Config"
$applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"

# physicalPath 및 bindingInformation 검색 및 파일 생성
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Line | Out-File -FilePath "$rawDir\iis_path1.txt" -Append
}

Set-Location -Path $rawDir
Get-Content "user.txt" | ForEach-Object {
    $user = $_
    $userInfo = net user $user
    If ($userInfo -match "계정 활성.*예") {
        "----------------------------------------------------" | Out-File "user_pw.txt" -Append
        (net user $user | Select-String "사용자 이름|암호 마지막 설정") | Out-File "user_pw.txt" -Append
        "----------------------------------------------------" | Out-File "user_pw.txt" -Append
    }
    Else {
        Write-Output "비활성 계정은 건너뜁니다."
    }
}

$policyInfo = Get-Content "$rawDir\Local_Security_Policy.txt" | Where-Object { $_ -match "최대암호사용기간" }
If ($policyInfo -match "\d+") {
    $maximumPasswordAge = $Matches[0]
    If ($maximumPasswordAge -lt 91) {
        "W-11,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "최대 암호 사용 기간 정책이 준수됩니다, 90일 미만으로 설정됨." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    } Else {
        "W-11,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt
