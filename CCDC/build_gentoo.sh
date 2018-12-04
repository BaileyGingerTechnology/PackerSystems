#!/bin/bash

cd scripts/gentoo
tar -czvf GentooInstall.tar.gz GentooInstall
mv GentooInstall.tar.gz ../../http/
cd ../..
