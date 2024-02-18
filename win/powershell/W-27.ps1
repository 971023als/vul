# 관리자 권한 확인 및 요청
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$PSCommandPath`"", "-Verb RunAs"
    exit
}

# 초기 설정
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_${computerName}_raw"
$resultDir = "C:\Window_${computerName}_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
$null = New-Item -Path "$rawDir\compare.txt" -ItemType File
cd $rawDir
Set-Content -Path "$rawDir\install_path.txt" -Value (Get-Location).Path
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config" | Out-File "$rawDir\iis_setting.txt"
Get-Content "$rawDir\iis_setting.txt" | Select-String -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
Get-Content "$rawDir\iis_path1.txt" | ForEach-Object { "$_" } | Out-File "$rawDir\line.txt"

# W-27 검사
$serviceStatus = Get-Service W3SVC -ErrorAction SilentlyContinue
if ($serviceStatus.Status -eq 'Running') {
    $iisAdminReg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\IISADMIN" -Name "ObjectName" -ErrorAction SilentlyContinue
    if ($iisAdminReg.ObjectName -ne "LocalSystem") {
        "W-27,N/A,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "IISADMIN 서비스가 LocalSystem 계정으로 실행되지 않으므로 특별한 조치가 필요하지 않습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-27,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "IISADMIN 서비스가 LocalSystem 계정으로 실행됩니다. 이는 권장되지 않습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-27,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "World Wide Web Publishing Service가 실행되지 않고 있습니다. IIS 관련 보안 설정을 검토할 필요가 없습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 데이터 캡처
"--------------------------------------W-27-------------------------------------" | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC" -Name "ObjectName" -ErrorAction SilentlyContinue | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\IISADMIN" -Name "ObjectName" -ErrorAction SilentlyContinue | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
"--------------------------localgroup Administrators----------------------------" | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
net localgroup Administrators | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
"-------------------------------------------------------------------------------" | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
