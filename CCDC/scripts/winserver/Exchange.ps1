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

scoop install grep --global

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

# Setup a web proxy so that even if they fix the hosts file internet still ded
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value "proxy.google.com"
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1