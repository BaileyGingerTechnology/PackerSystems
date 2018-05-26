#!/bin/bash

echo "We made it. Now for finishing touches."

sudo bash -c 'echo "gingertechweb" > /etc/hostname'

cd /

sudo rm finish-base.sh
sudo rm build-to-bash.sh
sudo rm package-manager.sh
sudo rm vpkg-provides.sh
sudo rm user-group-setup.sh