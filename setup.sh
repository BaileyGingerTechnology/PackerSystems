#!/bin/bash
# Author: Bailey Kasin

echo "Setting up project"

git pull
git submodule update --init --remote --recursive

echo "Latest changes pulled. Build ScoringEngine? (Requries Go and dpkg-deb, enter 'yes' to continue)"
read DoIt

if [ $DoIt != "yes" ]; then
 exit
fi

cd ScoringEngine/CyberPatriotScoringEngine
go build
mv CyberPatriotScoringEngine ../CheckScore/usr/local/bin/checkscore

cd ..
dpkg-deb --build CheckScore
mv CheckScore.deb ../CyberPatriot/files/
