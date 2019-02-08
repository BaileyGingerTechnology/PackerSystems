#!/bin/bash
# Author: Bailey Kasin

set -u
set -e

sudo bash -c "echo 'falls.gingertech.com' > /etc/hostname"
sudo hostname falls.gingertech.com

sudo mkdir -pv /usr/share/docker
sudo chown -v administrator:docker /usr/share/docker
cd /usr/share/docker

sudo yum install -y git ksh
yes password | chsh -s /bin/ksh

git clone https://github.com/mattermost/mattermost-docker.git
cd mattermost-docker
sed -i 's/\#\ args/args/g' docker-compose.yml
sed -i 's/\#\ \ \ -\ edition=team/\ \ -\ edition=team/g' docker-compose.yml

mkdir -p ./volumes/app/mattermost/{data,logs,config}
sudo chown -R 2000:2000 ./volumes/app/mattermost/
docker-compose up -d

cd /usr/share/docker

git clone https://github.com/BaileyGingerTechnology/system-manager.git
cd system-manager
docker-compose up -d

cd /usr/share/docker

docker run -d --restart unless-stopped -p 999:443 --name openvas mikesplain/openvas

if [ "$PACKER_BUILDER_TYPE" == "virtualbox-iso" ] || [ "$PACKER_BUILDER_TYPE" == "qemu" ]; then
  sudo sed -i '/dhcp/d' /etc/sysconfig/network-scripts/ifcfg-eth0
  cat /tmp/ip-config | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth0
elif [ "$PACKER_BUILDER_TYPE" == "vmware-iso" ]; then
  sudo sed -i '/dhcp/d' /etc/sysconfig/network-scripts/ifcfg-ens33
  cat /tmp/ip-config | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-ens33
fi
