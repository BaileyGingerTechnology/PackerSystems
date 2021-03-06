#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/22/2018
# Purpose : Install tools to do Gentoo mirrorselection

function get_sources() {
	# Got into tmp to avoid cluttering the machine
	cd /tmp || exit 1
	sleep 20
	# Clone the needed repos
	git clone https://github.com/BaileyGingerTechnology/mirrorselect.git
	git clone https://github.com/BaileyGingerTechnology/ssl-fetch.git
	git clone https://github.com/BaileyGingerTechnology/netselect.git
}

function install_sslfetch() {
	# Go into ssl-fetch and insall
	cd /tmp/ssl-fetch || exit 1
	python2 setup.py build
	python2 setup.py install
}

function install_netselect() {
	# Go into netselect and install
	cd /tmp/netselect || exit 1
	make && make install
}

function install_mirrorselect() {
	# Go into mirrorselect and install
	cd /tmp/mirrorselect || exit 1
	python2 setup.py build
	python2 setup.py install
}

# Keeps mirrorselect from getting pissy about not being
# to find the portage make config
mkdir /etc/portage
touch /etc/portage/make.conf

#pacman -S --noconfirm go
#git clone https://github.com/Jguer/yay.git
#cd yay
#make
#./yay -S gentoo-mirrorselect

get_sources
install_sslfetch
install_netselect
install_mirrorselect
