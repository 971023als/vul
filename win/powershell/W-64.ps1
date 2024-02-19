# 관리자 권한으로 스크립트 실행 요청
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$computerName = $env:COMPUTERNAME
$rawDirectory = "C:\Windows_Security_Audit\$computerName`_raw"
$resultDirectory = "C:\Windows_Security_Audit\$computerName`_result"

# 기존 정보 삭제 및 새 디렉터리 생성
Remove-Item -Path $rawDirectory, $resultDirectory -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawDirectory, $resultDirectory -Force | Out-Null

# 스크린 세이버 정책 확인
$screenSaveActive = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop").ScreenSaveActive
$screenSaverIsSecure = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop").ScreenSaverIsSecure
$screenSaveTimeOut = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop").ScreenSaveTimeOut

$resultText = @()

If ($screenSaveActive -eq "1") {
    If ($screenSaverIsSecure -eq "1") {
        If ($screenSaveTimeOut -lt 600) {
            $resultText += "W-64,O,| 스크린 세이버 정책 설정이 취약합니다."
        } else {
            $resultText += "W-64,X,| 스크린 세이버 정책 설정이 안전합니다."
        }
    } else {
        $resultText += "W-64,X,| 안전한 로그온이 요구되지 않습니다. 취약할 수 있습니다."
    }
} else {
    $resultText += "W-64,X,| 스크린 세이버가 비활성화되어 있습니다. 취약할 수 있습니다."
}

# 결과 저장
$resultText | Out-File "$resultDirectory\W-Window-$computerName-result.txt"

# 결과 출력
Write-Host "결과가 $resultDirectory 폴더에 저장되었습니다."
Write-Host "스크립트를 종료합니다."
