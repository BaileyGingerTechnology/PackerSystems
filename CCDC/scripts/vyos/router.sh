#!/bin/bash

set -e
set -x

sudo bash -c "echo 'deb http://archive.debian.org/debian squeeze main contrib non-free' > /etc/apt/sources.list"

sudo apt-get update