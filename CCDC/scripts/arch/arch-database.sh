#!/bin/bash

# Updating to most recent packages. Will probably have at least one thing out of date by the time it's used
echo "Updating"
pacman -Syu --noconfirm

# Install but don't configure the packages that I want
pacman -S --noconfirm --needed mariadb postgresql git base-devel zsh
# I plan to give the player a SQL file or two, probably one per database, and force them to figure out how to make it work
# PSQL isn't too bad, but MySQL/MariaDB can be painful on Arch, since the documentation is mostly but not completely correct

cd /tmp
git clone https://aur.archlinux.org/downgrader.git
cd downgrader
su - administrator -c "makepkg -si --noconfirm"

echo "alias cat='tac'" >> /home/administrator/.bashrc

(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/sudo /usr/bin/pacman -Syu --noconfirm") | crontab -

git clone https://github.com/juliavallina/windows-zsh-theme.git
ln -s windows-zsh-theme/windows.zsh-theme ~/.oh-my-zsh/custom/themes/windows.zsh-theme
su - administrator -c "ln -s windows-zsh-theme/windows.zsh-theme ~/.oh-my-zsh/custom/themes/windows.zsh-theme"
sed "s/ZSH_THEME/ZSH_THEME=\"windows\"/g" ~/.zshrc
su - administrator -c "echo 'ZSH_THEME=\"windows\"' >> ~/.zshrc"