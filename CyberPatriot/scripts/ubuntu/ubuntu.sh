#!/bin/bash

sudo apt update
sudo apt -y upgrade

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt -y install mysql-server

sudo apt -y install mysql-client apache2 php7.0

sudo apt -y install sddm
sudo apt -y install kubuntu-desktop