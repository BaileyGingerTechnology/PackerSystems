Import-Module ActiveDirectory
Import-Csv -Delimiter : -Path "C:\userlist.csv" | foreach-object {
  $userprincipalname = $_.SamAccountName + "@gingertech.com"
  New-ADUser -SamAccountName $_.SamAccountName -UserPrincipalName $userprincipalname -Name $_.Firstname -DisplayName $_.Firstname -GivenName $_.Firstname -SurName $_.Lastname -Department $_.Department -Path "CN=Users,DC=gingertech,DC=com" -AccountPassword (ConvertTo-SecureString "password321" -AsPlainText -force) -Enabled $True -PasswordNeverExpires $True -PassThru
}


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