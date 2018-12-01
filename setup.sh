#!/bin/bash
# Author: Bailey Kasin

echo "Setting up project"

git pull
git submodule update --init --remote --recursive

echo "Latest changes pulled. Build CyberPatriotScoringEngine? (Requries Go and dpkg-deb, enter 'yes' to continue)"
read -r DoIt

if [ "$DoIt" == "yes" ]; then
    cd ScoringEngine/CyberPatriotScoringEngine || exit 1
    go build
    mv CyberPatriotScoringEngine ../CheckScore/usr/local/bin/checkscore
    
    cd .. || exit 1
    dpkg-deb --build CheckScore
    mv CheckScore.deb ../CyberPatriot/files/

    cd .. || exit 1
fi

echo "Build CCDCScoringEngine? (Requries Go and dpkg-deb, enter 'yes' to continue)"
read -r DoIt

if [ "$DoIt" == "yes" ]; then
    cd ScoringEngine/CCDCScoringEngine || exit 1
    go build
    mv CCDCScoringEngine ../ScoringEngine/usr/bin/scoringengine
    
    cd .. || exit 1
    dpkg-deb --build ScoringEngine
    mv ScoringEngine.deb ../CCDC/files/Linux/Kali/
fi
