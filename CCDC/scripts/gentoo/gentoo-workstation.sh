#!/bin/bash
# Author: Bailey Kasin

echo "Reboot success. In system."

# Use the mirrorselect script to autoselect the best mirror to sync from
greenEcho "Now autopicking the closest mirror to you by downloading 100kb from each option and going with the fastest one."
mirrorselect -s4 -b10 -o -c ${COUNTRY:-USA} -D >> /etc/portage/make.conf