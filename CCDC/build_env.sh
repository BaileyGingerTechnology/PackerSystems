#!/bin/bash

# menu.sh
# Description: Bash menu generator
# 
# Created by Jamie Cruwys on 21/02/2014.
#

# Configuration
symbol="*"
paddingSymbol=" "
lineLength=70
charsToOption=1
charsToName=3

function generatePadding() {
    string="";
    for (( i=0; i < $2; i++ )); do
        string+="$1";
    done
    echo "$string";
}

# Generated configs
remainingLength=$(( $lineLength - 2 ));
line=$(generatePadding "${symbol}" "${lineLength}");
toOptionPadding=$(generatePadding "${paddingSymbol}" "${charsToOption}");
toNamePadding=$(generatePadding "$paddingSymbol" "$charsToName");

# generateText (text)
function generateText() {
    totalCharsToPad=$((remainingLength - ${#1}));
    charsToPadEachSide=$((totalCharsToPad / 2));
    padding=$(generatePadding "$paddingSymbol" "$charsToPadEachSide");
    totalChars=$(( ${#symbol} + ${#padding} + ${#1} + ${#padding} + ${#symbol} ));
    if [[ ${totalChars} < ${lineLength} ]]; then
        echo -e "${symbol}${padding}${1}${padding}${paddingSymbol}${symbol}";
    else
        echo -e "${symbol}${padding}${1}${padding}${symbol}";
    fi
}

# generateTitle (title)
function generateTitle() {  
    echo "$line"
    generateText ""
    generateText "$1"
    generateText ""
    echo "$line"
}

# generateOption (dialogType, optionNumber, optionName)
function generateOption() {
    tempOptionPadding=$toOptionPadding
    tempNamePadding=$toNamePadding
    if [[ $1 == "options" ]]; then
        if [[ $3 == "Exit" ]] || [[ $3 == "Return to the main menu" ]]; then
            optionString="[0]"
        else
            optionString="[$2]"
        fi
    elif [[ $1 == "instructions" ]]; then
        optionString="$2."
    fi
    charsToPadName=$(( ${lineLength} - ${#symbol} - ${#tempOptionPadding} - ${#optionString} - ${#tempNamePadding} - ${#3} - ${#symbol} ));
    namePadding=$(generatePadding "$paddingSymbol" "$charsToPadName");
    echo "${symbol}${tempOptionPadding}${optionString}${tempNamePadding}${3}${namePadding}${symbol}";
}

# generateOptionsFromArray (dialogType, array[options])
function generateOptionsFromArray() {
    index=1
    generateText "" 
    for OPTION in "${@:2}"
    do
        if [[ "$1" == "message" ]]; then
            generateText "$OPTION"
        else
            generateOption "$1" "$index" "$OPTION"
        fi
        ((index++))
    done
    generateText ""
}

# generateDialog (dialogType, dialogTitle, array[options])
function generateDialog() { 
    generateTitle "$2"
    generateOptionsFromArray "$1" "${@:3}"
    echo "$line";
}

# generateGoBackDialog (name, isNewLine)
function generateGoBackDialog() {
    if [[ $2 == "true" ]]; then
        echo -e "\n$line"
    else
        echo -e "$line"
    fi
    generateText ""
    generateOption "options" "0" "$1"
    generateText ""
    echo -e "$line"
}

# generateMessageDialog (title, array[message])
function generateMessageDialog() {
    if [[ "${#1}" > 0 ]]; then
        generateTitle "$1"
    fi
    generateOptionsFromArray "message" "${@:2}"
    echo "$line"
}

### End menu.sh

if [ "$#" -ne 1 ]; then
    echo "Need an argument for build type. vmware-iso or virtualbox-iso."
    echo "QEMU will be added as an option when I confirm that all builds work with it."

    exit 1
fi

function build_machine() {
  echo "Building $1 for $2!"

  if  [ "$1" == "gentoo-webserver" ]; then
    cd scripts/gentoo
    tar -czvf GentooInstall.tar.gz GentooInstall
    mv GentooInstall.tar.gz ../../http/
    cd ../..
  elif [ "$1" == "windows2012-ad" ]; then
    echo "Make sure that you have downloaded exchange.iso and placed it in files/Windows/Server/"
    echo "The file can be downloaded from https://files.gingertechnology.net"
    echo "VMware: Adjust the path to in the vmx_data part of windows2012-ad.json to be the correct full path to the file."
    echo "Virtualbox: You'll have to manually insert the disk, sorry."
    echo "QEMU: Should just work (tm)."
    
    read input
  elif [ "$1" == "vyos" ] && [ "$2" != "vmware-iso" ]; then
    echo "This build is not currently an option."
    echo "In this scenario, I recommend setting up an Untangle router."

    exit 0
  fi
  
  packer build -only="$2" $1.json | tee -a output.log
}

function build_all() {
  echo "Building environment for $2 with $1 as scorer!"

  build_machine windows2012-ad $2
  build_machine $1 $2
  build_machine arch-database $2
  build_machine centos-docker $2
  build_machine debian-workstation $2
  build_machine freebsd-bnmp $2
  build_machine gentoo-webserver $2
  build_machine lfs-webserver $2
  build_machine windows81-workstation $2
  build_machine vyos $2
}

list=(arch-database centos-docker debian-workstation freebsd-bnmp gentoo-webserver lfs-webserver vyos windows81-workstation windows2012-ad arch-scoring kali-scoring all none)
scorers=(arch-scoring kali-scoring)

generateDialog "options" "Which to build? If all, scoring server will be requested." "${list[@]}"
read -r buildTarget

case $buildTarget in
[1-9])
  mv output.log output.log.bak
  build_machine ${list[$buildTarget-1]} $1
  ;;
1[0-1])
  mv output.log output.log.bak
  build_machine ${list[$buildTarget-1]} $1
  ;;
12)
  generateDialog "options" "Which scoring server to build?" "${scorers[@]}"
  read -r scorer
  mv output.log output.log.bak
  build_all ${scorers[$scorer-1]} $1
  ;;
13)
  exit 0
  ;;
*)
  exit 1
  ;;
esac

echo ${list[$buildTarget-1]}
