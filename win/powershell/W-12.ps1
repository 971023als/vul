# 관리자 권한으로 실행되지 않았다면 관리자 권한 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "-File `"" + $MyInvocation.MyCommand.Definition + "`""
    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs
    Exit
}

# 콘솔 환경 설정
chcp 437
$Host.UI.RawUI.ForegroundColor = "Green"

# 디렉토리 및 파일 초기화
$computerName = $env:COMPUTERNAME
$rawDir = "C:\Window_$($computerName)_raw"
$resultDir = "C:\Window_$($computerName)_result"
Remove-Item -Path $rawDir, $resultDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $rawDir, $resultDir -ItemType Directory -Force | Out-Null
secedit /export /cfg "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Force
Set-Location -Path $rawDir
[System.IO.Path]::GetFullPath(".") | Out-File -FilePath "install_path.txt"
systeminfo | Out-File -FilePath "systeminfo.txt"

# IIS 설정 복사 및 분석
Copy-Item -Path "${env:WinDir}\System32\Inetsrv\Config\applicationHost.Config" -Destination "$rawDir\iis_setting.txt"
Select-String -Path "$rawDir\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Line >> "$rawDir\iis_path1.txt"
}

# 최소 암호 사용 기간 분석
$localSecurityPolicy = Get-Content "$rawDir\Local_Security_Policy.txt"
$minimumPasswordAge = $localSecurityPolicy | Where-Object { $_ -match "MinimumPasswordAge" } | ForEach-Object {
    If ($_ -match "\d+") {
        $matches[0]
    }
}
If ($minimumPasswordAge -gt 0) {
    $userPwFile = Get-Content "$rawDir\user_pw.txt"
    $policyMatch = $userPwFile | Select-String -Pattern "2012|2013|2014|2015" -Quiet
    If ($policyMatch) {
        "W-12,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "암호 정책 설정으로 인한 불일치 감지됨." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    } Else {
        "W-12,O,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
        "최소 암호 사용 기간 정책 준수 감지됨." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    }
} Else {
    "W-12,X,|" | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
    "암호 사용 기간 정책 분석을 건너뛰었거나 해당 없음." | Out-File "$resultDir\W-Window-$computerName-result.txt" -Append
}
