#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Main file of a suite of Gentoo install and config scripts

MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${ACOUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

echo "==> Setting local mirror"
curl -s "$MIRRORLIST" |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

source ./include/src/disk_functions.sh
source ./include/src/menu.sh
source ./include/src/tarball_functions.sh
source ./include/src/useful_functions.sh
source ./include/src/profile_functions.sh
source ./include/src/kernel_functions.sh
source ./include/src/system_var_functions.sh

echo "$(tput setaf 3)
    
 _____            _                    
|  __ \          | |                   
| |  \/ ___ _ __ | |_ ___   ___        
| | __ / _ \ '_ \| __/ _ \ / _ \       
| |_\ \  __/ | | | || (_) | (_) |      
 \____/\___|_| |_|\__\___/ \___/       
                                       
                                       
 _____          _        _ _           
|_   _|        | |      | | |          
  | | _ __  ___| |_ __ _| | | ___ _ __ 
  | || '_ \/ __| __/ _\` | | |/ _ \ '__|
 _| || | | \__ \ || (_| | | |  __/ |   
 \___/_| |_|___/\__\__,_|_|_|\___|_|   
                                       

    Version: 1.2
    Email: baileykasin@gmail.com
    For Latest Version Visit https://github.com/BaileyGingerTechnology/GentooInstall

    Copyright (C) 2017-2018 Bailey Kasin || Ginger Technology

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.

$(tput sgr0)";

rsync -ah --progress include/src/install_mirrorselect.sh /tmp/install_mirrorselect.sh
source ./include/src/preflight.sh

# Check for root privileges
check_root
# Check whether on Gentoo or other OS
check_distro

echo "Preflight done, should be good to go!"
echo "First step is disk setup."

# Print the current partitions of the chosen disk
parted -a optimal /dev/sda print
echo "Using disk /dev/sda. This next step will wipe that disk, is that okay?"

partition_disk /dev/sda

# Get the disk to mount from the file it was saved in and then append 4 to it

# Mount that disk to be used as the actual install location
mkdir /mnt/gentoo
mount /dev/sda4 /mnt/gentoo

toolLocation=$( find / |grep GentooInstall |head -n1 )
cd $toolLocation && cd ../
rsync -ah --progress GentooInstall /mnt/gentoo/

# Move the diskUsed file over
mkdir /mnt/gentoo/tmp
rsync -ah --progress /tmp/diskUsed.txt /mnt/gentoo/tmp

# Set time
ntpd -q -g

# Move into the tarball_functions script and continue there
download_tarball