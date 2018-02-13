#!/bin/bash

echo "Updating"
sudo apt update
sudo apt -y upgrade

echo "Installing MariaDB Server"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt -y install mysql-server

echo "Installing MariaDB Client, Apache, and PHP 7"
sudo apt -y install mysql-client apache2 php7.0
echo "Making database"
sudo mysql -u root -ppassword -e 'create database wordpress;'

echo "Setting up Wordpress site"
sudo mkdir -p /temp/wp
sudo chown -R administrator /temp/wp
cd /temp/wp
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cd wordpress

echo "Doing wordpress config"
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/root/g' wp-config.php
sed -i 's/password_here/password/g' wp-config.php

echo "Moving site files to web root"
sudo rm /var/www/html/index.html
sudo mv * /var/www/html

echo "Installing desktop"
sudo apt -y install sddm
sudo apt -y install kubuntu-desktop