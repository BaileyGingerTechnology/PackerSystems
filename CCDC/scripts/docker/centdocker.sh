#!/bin/bash
# Author: Bailey Kasin

set -u
set -e

# Sets hostname for after reboot
sudo bash -c "echo 'falls.gingertech.com' > /etc/hostname"
sudo hostname falls.gingertech.com

# This box will be running Docker containers
# So far Mattermost and one with that I made, so that players will have to
# decide which are good and bad
sudo mkdir -pv /usr/share/docker
sudo chown -v administrator:docker /usr/share/docker
cd /usr/share/docker

# This box will have ksh be the default shell
sudo yum install -y git ksh
yes password | chsh -s /bin/ksh

# Add users from CSV
cd /tmp
sudo newusers <userlist.csv

# Add the Mattermost containers
cd /usr/share/docker
git clone https://github.com/mattermost/mattermost-docker.git
cd mattermost-docker
# Set to team edition, rather than enterprise
sed -i 's/\#\ args/args/g' docker-compose.yml
sed -i 's/\#\ \ \ -\ edition=team/\ \ -\ edition=team/g' docker-compose.yml

# Make required data folders and bring up container, having it start with the host
mkdir -p ./volumes/app/mattermost/{data,logs,config}
sudo chown -R 2000:2000 ./volumes/app/mattermost/
docker-compose up -d

cd /usr/share/docker

# And now the one that I made, which is just a reverse shell listener
git clone https://github.com/BaileyGingerTechnology/system-manager.git
cd system-manager
docker-compose up -d

# Set static IP, setting NIC name as required by the build type
if [ "$PACKER_BUILDER_TYPE" == "virtualbox-iso" ] || [ "$PACKER_BUILDER_TYPE" == "qemu" ]; then
  sudo sed -i '/dhcp/d' /etc/sysconfig/network-scripts/ifcfg-eth0
  cat /tmp/ip-config | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth0
elif [ "$PACKER_BUILDER_TYPE" == "vmware-iso" ]; then
  sudo sed -i '/dhcp/d' /etc/sysconfig/network-scripts/ifcfg-ens33
  cat /tmp/ip-config | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-ens33
fi
