# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process PowerShell -ArgumentList "-File",("`"" + $MyInvocation.MyCommand.Definition + "`""), "-Verb", "RunAs"
    exit
}

# 콘솔 설정
chcp 437 > $null
$host.UI.RawUI.BackgroundColor = "DarkGreen"
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

Write-Output "------------------------------------------Setting---------------------------------------"
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"

# 이전 디렉토리 삭제 및 새 디렉토리 생성
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory -Force | Out-Null
Remove-Item -Path "$resultDir\W-Window-*.txt" -ErrorAction SilentlyContinue

# 로컬 보안 정책 내보내기
secedit /EXPORT /CFG "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Force | Out-Null

# 설치 경로 저장
$installPath = (Get-Location).Path
$installPath | Out-File -FilePath "$rawDir\install_path.txt"

# 시스템 정보 저장
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Output "------------------------------------------IIS Setting-----------------------------------"
# IIS 설정 복사
$applicationHostConfig = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
Get-Content -Path $applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$lines = Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation"
$lines | ForEach-Object { $_.Line } | Set-Content -Path "$rawDir\iis_path1.txt"

# MetaBase.xml 복사 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content -Path $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

# 정책 검사 및 결과 저장
Write-Output "------------------------------------------end-------------------------------------------"

Write-Output "------------------------------------------W-31------------------------------------------"
If (Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue).Status -eq "Running" {
    $asaFiles = Select-String -Path "$rawDir\iis_setting.txt" -Pattern "\.asax|\.asa"
    If ($asaFiles) {
        "W-30,X,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        "정책 위반: .asa 또는 .asax 파일에 대한 접근 제한이 없습니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        $asaFiles | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    } Else {
        "W-30,O,|" | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
        "정책 준수: .asa 및 .asax 파일이 적절히 제한됩니다." | Out-File -FilePath "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} Else {
    "W-30,O,|" | Out-File
