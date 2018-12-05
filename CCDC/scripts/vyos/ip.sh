#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

# Theorectically, this will NAT traffic and provide VMs with internet

configure
delete int ethernet eth0 address
delete int ethernet eth1 address

set int ethernet eth0 address dhcp
set int ethernet eth0 description NAT
set int ethernet eth1 address 172.16.16.1/24
set int ethernet eth1 description PROD

set system name-server 8.8.8.8
set system name-server 8.8.4.4
set system time-zone America/Los_Angeles

set nat source rule 10 outbound-interface eth1
set nat source rule 10 source address 172.16.16.0/24
set nat source rule 10 translation address masquerade
set nat source rule 10 protocol 'all'

commit
save
