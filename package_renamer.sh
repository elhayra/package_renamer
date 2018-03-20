#!/bin/bash

# provide args: PATH, new package name
# get package path
# for each folder and file change their name according to new name
# change text in files too


GREEN_TXT='\e[0;32m'
WHITE_TXT='\e[1;37m'
RED_TXT='\e[31m'
NO_COLOR='\033[0m'

# check for hardware argument, and determine installation type #
if [ $# -eq 3 ]
then  
    PKG_PATH=$1
    OLD_NAME=$2
    NEW_NAME=$3
    if [ ! -d "$PKG_PATH" ]; then
        printf "${RED_TXT}\nPath doesn't exists. Please provide valid path. ${NO_COLOR}\n"
        exit 1
    fi

else
    printf "${WHITE_TXT}\nWrong number of arguments. Please provide 3 args: <pkg path> <old name> <new name> ${NO_COLOR}\n"
    exit 1
fi

printf "${WHITE_TXT}\n***Renaming ${PKG_PATH} content***\n${NO_COLOR}"

# basename 

change_files_name() {
    for f in "$1"/*; do
        if [ -d "$f" ];then #directory
            echo "dir: `basename $f`"
            change_files_name "$f"
        elif [ -f "$f" ]; then #file
            echo "file: `basename $f`"
        fi
    done
}

change_files_name $PKG_PATH