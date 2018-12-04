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

# I can't remember why this is here, but I'm leaving it just in case for now
scoop install grep --global

# The rest of this scripts creates the Active Directory Domain for the environment
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment
Install-ADDSForest `
  -CreateDnsDelegation:$false `
  -DatabasePath "C:\Windows\NTDS" `
  -DomainMode "Win2012R2" `
  -DomainName "gingertech.com" `
  -SafeModeAdministratorPassword:(ConvertTo-SecureString -String password -AsPlainText -Force) `
  -DomainNetbiosName "GINGERTECH" `
  -ForestMode "Win2012R2" `
  -InstallDns:$true `
  -LogPath "C:\Windows\NTDS" `
  -NoRebootOnCompletion:$true `
  -SysvolPath "C:\Windows\SYSVOL" `
  -Force:$true

Write-Host "AD Good"

# Even though the setup is successful, the script will exit with code 3010, which
# means "success but reboot needed" which causes Packer to fail the build. So change
# exit code to 0
exit 0