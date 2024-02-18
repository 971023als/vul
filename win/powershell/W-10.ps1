# 관리자 권한으로 실행 중인지 확인
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # 현재 스크립트를 관리자 권한으로 재실행
    Start-Process PowerShell -ArgumentList "-File `"$PSCommandPath`"", "-NoProfile", "-ExecutionPolicy Bypass" -Verb RunAs
    Exit
}

# 콘솔 창 설정
chcp 437
$host.UI.RawUI.BackgroundColor = "DarkGreen"
Clear-Host

# 필요한 디렉토리 삭제 및 생성
$computerName = $env:COMPUTERNAME
$baseDir = "C:\Window_${computerName}"
$rawDir = "${baseDir}_raw"
$resultDir = "${baseDir}_result"

Remove-Item -Path "${rawDir}", "${resultDir}" -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path "${rawDir}", "${resultDir}" -ItemType Directory -Force | Out-Null

# 초기 파일 생성 및 시스템 정보 수집
secedit /export /cfg "${rawDir}\Local_Security_Policy.txt"
fsutil file createnew "${rawDir}\compare.txt" 0
Get-Location > "${rawDir}\install_path.txt"
systeminfo > "${rawDir}\systeminfo.txt"

# IIS 설정 파일 읽기
$iisConfig = Get-Content -Path "${env:WinDir}\System32\Inetsrv\Config\applicationHost.Config"
$iisConfig > "${rawDir}\iis_setting.txt"

# 필터링 및 경로 추출
Select-String -Path "${rawDir}\iis_setting.txt" -Pattern "physicalPath|bindingInformation" | ForEach-Object {
    $_.Line >> "${rawDir}\iis_path1.txt"
}

cd "${rawDir}"
Get-Content "user.txt" | ForEach-Object {
    $user = $_.Trim()
    $userInfo = net user $user
    if ($userInfo -match "계정 활성 상태\s*:\s*예") {
        "----------------------------------------------------" >> "user_pw.txt"
        net user $user | Select-String "사용자 이름|마지막으로 암호 설정됨" >> "user_pw.txt"
        "----------------------------------------------------" >> "user_pw.txt"
    }
}

# 최대암호사용기간 분석
$policyInfo = Get-Content "${rawDir}\Local_Security_Policy.txt" | Select-String "최대암호사용기간"
if ($policyInfo -and $policyInfo -match "\d+") {
    $maxAge = [int]$Matches[0]
    if ($maxAge -lt 91) {
        # 정책 준수 시의 처리 로직
        "정책 준수" > "${resultDir}\W-Window-${computerName}-result.txt"
    } else {
        # 정책 비준수 시의 처리 로직
        "정책 비준수" > "${resultDir}\W-Window-${computerName}-result.txt"
    }
}
