Import-Module ActiveDirectory
Import-Csv -Delimiter : -Path "C:\userlist.csv" | foreach-object {
  $userprincipalname = $_.SamAccountName + "@gingertech.com"
  New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName $userprincipalname -Name $_.Firstname -DisplayName $_.Firstname -GivenName $_.Firstname -SurName $_.Lastname -Department $_.Department -Path "CN=Users,DC=gingertech,DC=com" -AccountPassword (ConvertTo-SecureString "password321" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru
}

# Authors: James Block and Bailey Kasin

# Install the needed WindowsFeatures to support IIS and FTP
# they get weird if you one line it
Install-WindowsFeature -Name Web-Server
Install-WindowsFeature -Name Web-Mgmt-Tools
Install-WindowsFeature -Name Web-FTP-Server
Install-WindowsFeature -Name Web-FTP-Ext

# Gives the ability to path with IIS:\
Import-Module WebAdministration

# Name and port for the FTP server. Does not have to be standard
New-WebFtpSite -Name "FTP" -Port "21" -Force

# Set home path for FTP
cmd /c \Windows\System32\inetsrv\appcmd set SITE "FTP" "-virtualDirectoryDefaults.physicalPath:REPLACE"

# Honestly not sure
Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0

# Set which forms of authentication are allowed
Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.authentication.anonymousAuthentication.enabled -Value $true
Set-ItemProperty "IIS:\Sites\FTP" -Name ftpServer.security.authentication.basicAuthentication.enabled -Value $true

# How isolated is the user
# 0:
# 1:
# 2:
# 3:
# 4: Not at all
Set-ItemProperty "IIS:\Sites\FTP" -Name ftpserver.userisolation.mode -Value 4

# Base permissions for the server and which users can access
Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="";permissions="Read,Write";users="*"} -PSPath IIS:\ -location "FTP"

# Restart server for changes to take effect
Restart-WebItem "IIS:\Sites\FTP"

# END FTP SETUP SCRIPT

# Setup a web proxy so that even if they fix the hosts file internet still ded
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value "proxy.google.com"
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1

# Disable autologon
$Regkey = "HKLM:\Software\Microsoft\Windows NT\Currentversion\WinLogon"
$DefaultUserName = ''
$DefaultPassword = ''

# Disable firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# Setup for Scoring Engine
scoop install grep --global
mkdir C:\ProgramData\gingertechengine