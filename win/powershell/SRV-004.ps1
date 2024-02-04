# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 콘솔 환경 설정
$Host.UI.RawUI.BackgroundColor = "DarkGreen"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host
Write-Host "------------------------------------------Setting---------------------------------------" -ForegroundColor Green

# 작업 디렉토리 초기화
$ComputerName = $env:COMPUTERNAME
$RawDir = "C:\Window_${ComputerName}_raw"
$ResultDir = "C:\Window_${ComputerName}_result"
Remove-Item $RawDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $ResultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $RawDir, $ResultDir | Out-Null

# 보안 정책 및 시스템 정보 수집
secedit /EXPORT /CFG "$RawDir\Local_Security_Policy.txt"
New-Item -ItemType File -Path "$RawDir\compare.txt" -Force | Out-Null
Get-Location > "$RawDir\install_path.txt"
Get-SystemInfo | Out-File "$RawDir\systeminfo.txt"

# IIS 설정 정보 수집
Write-Host "------------------------------------------IIS Setting-----------------------------------" -ForegroundColor Green
Get-Content $env:windir\System32\Inetsrv\Config\applicationHost.Config | Out-File "$RawDir\iis_setting.txt"
Select-String -Path "$RawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | Out-File "$RawDir\iis_paths.txt"

# SMTP 서비스 검사
Write-Host "------------------------------------------SMTP Service Check-----------------------------------------" -ForegroundColor Green
"Checking SMTP service status..." | Out-File "$ResultDir\W-Window-$ComputerName-rawdata.txt" -Append
Get-Service smtp | Out-File "$ResultDir\W-Window-$ComputerName-rawdata.txt" -Append
"--------------------------------------------------------------------------------" | Out-File "$ResultDir\W-Window-$ComputerName-rawdata.txt" -Append

# SMTP 서비스 점검 결과 기록
"SRV-001 (Windows) SNMP Community 스트링 설정 미흡" | Out-File "$ResultDir\W-Window-$ComputerName-rawdata.txt" -Append
"SRV-004 (Windows) 불필요한 SMTP 서비스 실행 여부 점검" | Out-File "$ResultDir\W-Window-$ComputerName-rawdata.txt" -Append
netstat -an | Select-String ":25" | Out-File "$ResultDir\W-Window-$ComputerName-rawdata.txt" -Append

Write-Host "------------------------------------------End of Checks------------------------------------------" -ForegroundColor Green
Write-Host "점검 완료. 결과 파일은 $ResultDir\W-Window-$ComputerName-rawdata.txt 에 저장되었습니다." -ForegroundColor Yellow
