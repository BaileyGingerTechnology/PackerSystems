#ip
'
########################################################
#                     SYSTEM INFO                      #
########################################################
'
#hostname, IP, DOMAIN, and patches
systeminfo

#ports
'
########################################################
#                   LISTENING PORTS                    #
########################################################
'

$net = get-nettcpconnection | where {$_.State -eq 'Listen'} | sort localport
($net).LocalPort

#in case powershell shits itself
#netstat -an | findstr

'
########################################################
#                      LOCAL USERS                     #
########################################################
'
#users
net user


'
########################################################
#                      Services                        #
########################################################
'
#Services

#in case powershell be mad
#cmd.exe /c 'sc query'

$serv = get-service | where {$_.Status -eq 'Running'} | sort Name
$serv


'
########################################################
#                      Shares                          #
########################################################
'

net share



'
########################################################
#                      Firewall                        #
########################################################
'


$fire = get-netfirewallprofile
($fire).Enabled

#if powershell big gay
#netsh advfirewall show allprofiles state

