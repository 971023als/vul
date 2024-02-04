# 愿由ъ옄 沅뚰븳?쇰줈 ?ㅽ뻾 ?붿껌
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# 肄섏넄 ?섍꼍 ?ㅼ젙
$OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "------------------------------------------Setting---------------------------------------" -ForegroundColor Green

# ?붾젆?곕━ ?ㅼ젙
$computerName = $env:COMPUTERNAME
$rawPath = "C:\Window_${computerName}_raw"
$resultPath = "C:\Window_${computerName}_result"

Remove-Item $rawPath -Recurse -ErrorAction SilentlyContinue
Remove-Item $resultPath -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $rawPath, $resultPath -Force

# ?쒖뒪???뺣낫 諛?蹂댁븞 ?뺤콉 ?대낫?닿린
secedit /EXPORT /CFG "$rawPath\Local_Security_Policy.txt"
New-Item -ItemType File -Path "$rawPath\compare.txt" -Force
[System.IO.File]::WriteAllText("$rawPath\install_path.txt", (Get-Location).Path)

# ?쒖뒪???뺣낫
systeminfo | Out-File -FilePath "$rawPath\systeminfo.txt"

# IIS ?ㅼ젙
$applicationHostConfig = Get-Content $env:windir\System32\inetsrv\Config\applicationHost.Config
$applicationHostConfig | Out-File -FilePath "$rawPath\iis_setting.txt"
$applicationHostConfig | Select-String "physicalPath|bindingInformation" | Out-File -FilePath "$rawPath\iis_path.txt"

# MetaBase.xml ?뺣낫 (IIS 6 ?명솚??紐⑤뱶?먯꽌 ?ъ슜??寃쎌슦)
$metaBasePath = "$env:WINDIR\system32\inetsrv\MetaBase.xml"
If (Test-Path $metaBasePath) {
    Get-Content $metaBasePath | Out-File -FilePath "$rawPath\iis_setting.txt" -Append
}

Write-Host "------------------------------------------End-------------------------------------------" -ForegroundColor Green

# SNMP 諛?SMTP ?쒕퉬???ㅼ젙 ?먭? (SRV-001, SRV-004)
# SNMP 諛?SMTP ?ㅼ젙 ?먭????꾩슂??濡쒖쭅??異붽??섏꽭??
