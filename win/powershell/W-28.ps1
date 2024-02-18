# 관리자 권한 요청
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
Set-Location -Path $rawDir
[System.IO.File]::WriteAllText("$rawDir\install_path.txt", (Get-Location).Path)
systeminfo | Out-File "$rawDir\systeminfo.txt"

# IIS 설정 분석
Get-Content "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config" | Out-File "$rawDir\iis_setting.txt"
Get-Content "$rawDir\iis_setting.txt" | Select-String -Pattern "physicalPath|bindingInformation" | Out-File "$rawDir\iis_path1.txt"
$line = Get-Content "$rawDir\iis_path1.txt" -Raw
Set-Content -Path "$rawDir\line.txt" -Value $line
1..5 | ForEach-Object {
    Get-Content "$rawDir\line.txt" | ForEach-Object { $_ -split '\*'} | Select-Object -Index ($_-1) | Out-File "$rawDir\path$_.txt"
}
Get-Content "$env:WinDir\System32\Inetsrv\MetaBase.xml" | Out-File "$rawDir\iis_setting.txt"

# W-28 검사
$serviceStatus = Get-Service W3SVC -ErrorAction SilentlyContinue
if ($serviceStatus.Status -eq 'Running') {
    $pathsChecked = $False
    1..5 | ForEach-Object {
        $path = Get-Content "$rawDir\path$_.txt" -ErrorAction SilentlyContinue
        if (Test-Path $path) {
            Get-ChildItem -Path $path -Filter "*.lnk" | ForEach-Object {
                "$path 경로에 단축 파일(*.lnk)이 발견되었습니다" | Out-File "$rawDir\W-28.txt" -Append
                $pathsChecked = $True
            }
        }
    }
    if ($pathsChecked) {
        "W-28,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "중요 IIS 경로에 단축 파일이 발견되어 보안 위험이 있습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        Get-Content "$rawDir\W-28.txt" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    } else {
        "W-28,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "중요 IIS 경로에 무단 단축 파일이 없습니다. 시스템이 보안 표준을 준수합니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} else {
    "W-28,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "World Wide Web Publishing Service가 실행되지 않고 있습니다. 단축 파일을 확인할 필요가 없습니다." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}

# 결과 데이터 캡처
"--------------------------------------W-28-------------------------------------" | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
Get-Content "$rawDir\W-28.txt" | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
"-------------------------------------------------------------------------------" | Out-File "$resultDir\W-Window-$computerName-rawdata.txt" -Append
