#!/bin/bash

# Updating to most recent packages. Will probably have at least one thing out of date by the time it's used
echo "Updating"
sudo apt update
sudo apt -y upgrade

# Setting up LAMP stack
echo "Installing MariaDB Server"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt -y install mysql-server

echo "Installing MariaDB Client, Apache, and PHP 7"
sudo apt -y install mysql-client apache2 php7.0 php7.0-gd php7.0-mysql libapache2-mod-php7.0 php7.0-mcrypt
echo "Making database"
sudo mysql -u root -ppassword -e 'create database wordpress;'
# Move into and taking ownership of temporary folder
sudo chown -R administrator /temp/wp
cd /temp/wp
# Import database
sudo mysql -u root -ppassword -p wordpress < /temp/wp/wordpress.sql

# I made changes to the Wordpress site, so get it from the files folder rather than
# downloading the latest version. This also helps keep it a little outdated. I want
# the player to have to work a bit for it
echo "Setting up Wordpress site"
cd /temp/wp
tar xvf wordpress.tar
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cd wordpress

# Just in case I ever use a different MySQL password for some reason, I'll
# keep this here
echo "Doing wordpress config"
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/root/g' wp-config.php
sed -i 's/password_here/password/g' wp-config.php

# Move files to the correct folder. Right now I'm leaving /temp existing for debugging
# reasons, but by version 1.0, I'll be deleting the /temp folder after moving contents
echo "Moving site files to web root"
sudo rm /var/www/html/index.html
sudo mv * /var/www/html

# Make sure that index.php is the first file loaded for the website
echo "Doing Apache2 config"
sed -i 's/index.php\ //g' /etc/apache2/mods-enabled/dir.conf
sed -i 's/index.html/index.php/g' /etc/apache2/mods-enabled/dir.conf

# Install KDE, best desktop. To be honest, I should use XFCE or LXDE, but KDE so good
echo "Installing desktop"
sudo apt -y install sddm
sudo apt -y install kubuntu-desktop

# Let's start intentioally making ourselves vulnerable, that's always fun

# To start off, let's make ourselves vulnerable to Shellshock
sudo bash -c 'echo "deb http://us.archive.ubuntu.com/ubuntu trusty main"'
sudo apt update
sudo apt install bash=4.3-6ubuntu1