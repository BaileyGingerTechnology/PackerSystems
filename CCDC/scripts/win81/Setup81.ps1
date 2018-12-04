# Author: Bailey Kasin
# This script sets/messes up the Windows Server image

# Share the C:\ drive, because duh, that's a great idea
net share FullDrive=C:\ /grant:Everyone,Full

function Disable-PasswordComplexity {
  param()

  $secEditPath = [System.Environment]::ExpandEnvironmentVariables("%SystemRoot%\system32\secedit.exe")
  $tempFile = [System.IO.Path]::GetTempFileName()

  $exportArguments = '/export /cfg "{0}" /quiet' -f $tempFile
  $importArguments = '/configure /db secedit.sdb /cfg "{0}" /quiet' -f $tempFile

  Start-Process -FilePath $secEditPath -ArgumentList $exportArguments -Wait

  $currentConfig = Get-Content -Path $tempFile

  $currentConfig = $currentConfig -replace 'PasswordComplexity = .', 'PasswordComplexity = 0'
  $currentConfig = $currentConfig -replace 'MinimumPasswordLength = .', 'MinimumPasswordLength = 0'
  $currentConfig | Out-File -FilePath $tempFile

  Start-Process -FilePath $secEditPath -ArgumentList $importArguments -Wait
   
  Remove-Item -Path .\secedit.sdb
  Remove-Item -Path $tempFile
}

# Passwords are for the weak
Disable-PasswordComplexity

# Setup some fun routing using the hosts file
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 google.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 bing.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 yahoo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 duckduckgo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 startpage.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 aol.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.google.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.bing.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.yahoo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.duckduckgo.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.startpage.com"
Add-Content C:\Windows\System32\drivers\etc\hosts "0.0.0.0 www.aol.com"

# Disable firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

rm C:\ninite.exe
rm C:\userlist.csv
rm C:\WinBullshit.ps1