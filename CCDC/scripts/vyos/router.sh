#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y fortune-mod cowsay

cat /tmp/cowsay.txt >>~/.bashrc

cat /tmp/cowsay.txt | sudo tee -a /root/.bashrc
