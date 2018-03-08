#!/bin/bash

# Updating to most recent packages. Will probably have at least one thing out of date by the time it's used
echo "Updating"
pacman -Syu --noconfirm

# Install but don't configure the packages that I want
pacman -S --noconfirm --needed mariadb postgresql git base-devel tac
# I plan to give the player a SQL file or two, probably one per database, and force them to figure out how to make it work
# PSQL isn't too bad, but MySQL/MariaDB can be painful

cd /tmp
git clone https://aur.archlinux.org/downgrader.git

echo "alias cat='tac'" >> /home/administrator/.bashrc