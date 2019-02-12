#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Need an argument for build type. vmware-iso or virtualbox-iso."

    exit 1
fi


cd scripts/gentoo
tar -czvf GentooInstall.tar.gz GentooInstall
mv GentooInstall.tar.gz ../../http/
cd ../..

packer build -only="$1" -on-error=ask gentoo-webserver.json | tee output.log
