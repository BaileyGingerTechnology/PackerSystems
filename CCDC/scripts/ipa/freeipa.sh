#!/bin/bash
# Author: Bailey Kasin

echo "ipa.gingertech.com" > /etc/hostname
hostname ipa.gingertech.com

firewall-cmd --permanent --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,53/tcp,88/udp,464/udp,53/udp,123/udp}
firewall-cmd --reload

yum install -y bind-utils