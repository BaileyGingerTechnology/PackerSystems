#!/bin/bash
# Author  : Bailey Kasin
# Date    : 1/9/2018
# Purpose : Useful functions to add ease of use

function redEcho
{
    echo -e $(tput setaf 1)$1$(tput sgr0)
}

function greenEcho
{
    echo $(tput setaf 2)$1$(tput sgr0)
}

function orangeEcho
{
    echo $(tput setaf 3)$1$(tput sgr0)
}

function blueEcho
{
    echo $(tput setaf 4)$1$(tput sgr0)
}

function pinkEcho
{
    echo $(tput setaf 5)$1$(tput sgr0)
}