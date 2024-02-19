# 관리자 권한 확인 및 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments -join ' '
    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs
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

# 로컬 보안 정책 내보내기 및 비교 파일 생성
secedit /EXPORT /CFG "$rawDir\Local_Security_Policy.txt"
New-Item -Path "$rawDir\compare.txt" -ItemType File -Force | Out-Null

# 설치 경로 저장
$installPath = (Get-Location).Path
$installPath | Out-File -FilePath "$rawDir\install_path.txt"

# 시스템 정보 저장
systeminfo | Out-File -FilePath "$rawDir\systeminfo.txt"

Write-Output "------------------------------------------IIS Setting-----------------------------------"
# IIS 설정 복사 및 처리
$applicationHostConfig = "$env:WinDir\System32\Inetsrv\Config\applicationHost.Config"
Get-Content -Path $applicationHostConfig | Out-File -FilePath "$rawDir\iis_setting.txt"
$lines = Get-Content -Path "$rawDir\iis_setting.txt" | Select-String "physicalPath|bindingInformation"
$line = $lines -join ""
$line | Out-File -FilePath "$rawDir\line.txt"

1..5 | ForEach-Object {
    $pathFile = "$rawDir\path$_.txt"
    $lines | ForEach-Object {
        if ($_ -match "^(.*?)(\*{$_}.*?)$") {
            $matches[2] | Out-File -FilePath $pathFile -Append
        }
    }
}

# MetaBase.xml 추가 (해당하는 경우)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content -Path $metaBasePath | Out-File -FilePath "$rawDir\iis_setting.txt" -Append
}

Write-Output "------------------------------------------end-------------------------------------------"

# 디렉토리 권한 검사 및 결과 처리
Write-Output "------------------------------------------W-32------------------------------------------"
If ((Get-Service -Name "W3SVC" -ErrorAction SilentlyContinue).Status -eq "Running") {
    Get-Content "$rawDir\http_path.txt" | ForEach-Object {
        $path = $_.Trim()
        Push-Location $path
        "-----------------------해당 경로-------------------------" | Out-File "$rawDir\W-32.txt" -Append
        $acl = (Get-Acl $path).Access | Where-Object { $_.IdentityReference -eq "Everyone" }
        If ($acl) {
            Get-Acl $path | Format-List | Out-File "$rawDir\W-32.txt" -Append
        } Else {
            Write-Output ""
        }
        Pop-Location
    }
    Set-Location -Path $installPath
    $everyoneAccess = Select-String -Path "$rawDir\W-
