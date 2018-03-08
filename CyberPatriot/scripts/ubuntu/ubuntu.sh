#!/bin/bash
# Author: Bailey Kasin

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
# Move into and take ownership of temporary folder
sudo chown -R administrator /temp/wp
cd /temp/wp
# Import database
sudo mysql -u root -ppassword wordpress < /temp/wp/wordpress.sql

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
sudo bash -c 'echo "deb http://us.archive.ubuntu.com/ubuntu trusty main" >> /etc/apt/sources.list'
sudo apt update
sudo apt -y --allow-downgrades install bash=4.3-6ubuntu1

# Now we need ourselves some vsftpd. Uber secure
sudo apt -y install vsftpd
sudo sed -i 's/NO/YES/g' /etc/vsftpd.conf
sudo sed -i 's/ssl_enable=YES/ssl_enable=NO/g' /etc/vsftpd.conf
sudo sed -i 's/xferlog_enable=YES/xferlog_enable=NO/g' /etc/vsftpd.conf
sudo sed -i 's/#anon_upload_enable=YES/anon_upload_enable=YES/g' /etc/vsftpd.conf
sudo systemctl enable vsftpd

# Let's get some VNC up in here
sudo apt -y install tightvncserver

# Gonna add a couple of users with weak passwords
cd /temp/other/
sudo newusers < userlist.csv
sudo usermod -aG sudo bkasin
sudo usermod -aG sudo rparker

# Let's have some fun with SSH settings.
sudo sed -i 's/Protocol\ 2/Protocol\ 1/g' /etc/ssh/sshd_config
sudo sed -i 's/prohibit-password/yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PermitEmptyPasswords\ no/PermitEmptyPasswords\ yes/g' /etc/ssh/sshd_config

# Back in my day, we had to work if we wanted Google!
sudo bash -c 'echo "34.196.155.28 google.com
0.0.0.0 bing.com
0.0.0.0 yahoo.com
0.0.0.0 duckduckgo.com
0.0.0.0 startpage.com
0.0.0.0 aol.com
34.196.155.28 www.google.com
0.0.0.0 www.bing.com
0.0.0.0 www.yahoo.com
0.0.0.0 www.duckduckgo.com
0.0.0.0 www.startpage.com
0.0.0.0 www.aol.com" >> /etc/hosts'

# Setting up something a bit annoying but not necessarily bad. Gonna use Shellshock to force the machine to reboot via a cronjob
sudo mkdir /etc/gingertechengine/
sudo mv /temp/other/notify.sh /etc/gingertechengine/
sudo mv /temp/other/post_score /etc/gingertechengine/
sudo chmod +x /etc/gingertechengine/*

(crontab -l 2>/dev/null; echo "* */1 * * * /etc/gingertechengine/notify.sh") | crontab -

# Set Apache2 and MySQL to start at boot
echo "sudo /etc/init.d/apache2 start" >> /home/administrator/.bash_profile
echo "sudo /etc/init.d/mysql start" >> /home/administrator/.bash_profile

# Setup the database for ScoringEngine
mysql -u root -ppassword -e "grant all privileges on wordpress.* to 'ScoringEngine'@'localhost' identified by 'password123';"
mysql -u root -ppassword -e "use wordpress; insert into wp_users(ID,user_login,user_pass,user_nicename,user_email,user_url,user_registered,user_status,display_name) values (2,'ScoringEngine','\$1\$tcm9IzQV\$GjrEqkpJ9.cPsScdYvD991','ScoringEngine','bailey@gingertechnology.net','https://blog.gingertechnology.net',NOW(),0,'ScoringEngine');"
cd /temp/other
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Make scoring engine user
sudo useradd -M  -s /bin/bash ScoringEngine
sudo usermod -aG sudo ScoringEngine
sudo bash -c 'echo "*/15 * * * * ScoringEngine /etc/gingertechengine/post_score" >> /etc/crontab'
sudo chown -R ScoringEngine /etc/gingertechengine
sudo chmod +x /etc/gingertechengine/post_score

# Kill temp dir
sudo rm -rf /temp/*