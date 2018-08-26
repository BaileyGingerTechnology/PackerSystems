# Whew boi, kill me now
Set-Location -Path E:\ -PassThru
.\Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms
.\Setup.exe /PrepareAD /OrganizationName:gingertech /IAcceptExchangeServerLicenseTerms
.\Setup.exe /PrepareAD /OrganizationName:gingertech /IAcceptExchangeServerLicenseTerms
.\Setup.exe /mode:Install /role:Mailbox /OrganizationName:gingertech /IAcceptExchangeServerLicenseTerms
# Theoretically Exchange might be installed?

# Disable autologon
$Regkey = "HKLM:\Software\Microsoft\Windows NT\Currentversion\WinLogon"
Set-ItemProperty -Path $Regkey -Name DefaultUserName -Value ''
Set-ItemProperty -Path $Regkey -Name DefaultPassword -Value ''

# Disable firewall
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

# I can't remember why this is here, but I'm leaving it just in case for now
scoop install grep --global

# Setup a web proxy so that even if they fix the hosts file internet still ded
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value "blog.gingertechnology.net"
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1