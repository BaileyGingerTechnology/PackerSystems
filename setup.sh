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
    cd ForensicDeployment || exit 1
    go build
    mv ForensicDeployment ../CheckScore/usr/local/bin/ForensicDeployment
    
    cd .. || exit 1
    dpkg-deb --build CheckScore
    mv CheckScore.deb ../CyberPatriot/files/

    cd .. || exit 1
fi

echo "Build CCDCScoringEngine? This build is for Kali. Arch will be asked after. (Requries Go and dpkg-deb, enter 'yes' to continue)"
read -r DoIt

if [ "$DoIt" == "yes" ]; then
    cd ScoringEngine/ScoringSources || exit 1
    ./build_sources.sh
    
    cd ../CCDCScoringEngine || exit 1
    go build
    mv CCDCScoringEngine ../ScoringEngine/usr/bin/scoringengine
    
    cd .. || exit 1
    dpkg-deb --build ScoringEngine
    mv ScoringEngine.deb ../CCDC/files/Linux/Kali/
    cd .. || exit 1
fi

echo "Build CCDCScoringEngine for Arch?"
read -r DoIt

if [ "$DoIt" == "yes" ]; then
    cp CCDC/files/Linux/Kali/ScoringEngine.deb ScoringEngine/ScoringEngineArch/
    cd ScoringEngine/ScoringEngineArch || exit 1
    
    check=$(sha256sum ScoringEngine.deb | awk '{print $1}')
    sed -i "/sha256sums/s/.*/sha256sums=(\'$check\')/" PKGBUILD
    makepkg --printsrcinfo > .SRCINFO
    makepkg

    mv *.tar.xz ../../CCDC/files/Linux/Arch-Scoring/ScoringEngine.pkg.tar.xz

    cd ../../ || exit 1
fi
