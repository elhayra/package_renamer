#!/bin/bash

#This script go recursively over all files in chosen path, 
#and if folder or file or file content contains chosen string
#it will replace it with the new requested string.

#To use this script provide 3 args: <pkg path> <old name> <new name> 
#e.g. /package_renamer.sh path/to/some/folder/ some_old_string some_new_string

GREEN_TXT='\e[0;32m'
WHITE_TXT='\e[1;37m'
RED_TXT='\e[31m'
NO_COLOR='\033[0m'

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

change_files_name() {
    FIRST_FILE=true
    for f in "$1"/*; do # go recursively over all files under chosen path
        if [ -d "$f" ];then # directory
            echo "checking dir at: $f ..."
            DIR_NAME=`basename $f`
            if [[ $DIR_NAME = *$OLD_NAME* ]]; then
                DIR_NEW_NAME="${DIR_NAME//$OLD_NAME/$NEW_NAME}"
                echo "old name detected. replacing $DIR_NAME with $DIR_NEW_NAME"
                cd $f/..
                mv $DIR_NAME $DIR_NEW_NAME
            fi
            change_files_name "$f"
            echo "done."
        elif [ -f "$f" ]; then #file
            if $FIRST_FILE; then
                echo "\\"
                FIRST_FILE=false
            else
                echo " |"
            fi
            echo " *-> checking file at: $f and editing content ..."
            FILE_NAME=`basename $f`
            FILE_PATH=`dirname $f`
            FILE_NEW_NAME="${FILE_NAME//$OLD_NAME/$NEW_NAME}"
            sed -i -e 's/'"$OLD_NAME"'/'"$NEW_NAME"'/g' $f # replace file content
            if [[ $FILE_NAME = *$OLD_NAME* ]]; then
                echo " ***old name detected. replacing $FILE_NAME with $FILE_NEW_NAME ***"
                cd $FILE_PATH
                mv $FILE_NAME $FILE_NEW_NAME
                echo "done."
            fi
            change_files_name "$f"
        fi
    done
}

change_files_name $PKG_PATH

echo "replacing completed"
