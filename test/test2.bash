#!/usr/bin/env bash

source ../emitter.bash


CreateFile() {
    local ftocreate=$1

    echo -e "Love is a name \nSex is a game\n Play the Game\n Forget the name " > "$ftocreate"
    
    printf "%s\n" "$ftocreate have been created"
    event emit showfile "$ftocreate"
}

ReadFile() {
    local file=$1
    echo "------------------------- READING $file -----------------------"
    while read log;do
	printf "%s\n" "$log"
    done < "$file"
    echo "------------------------- DONE READING $file ------------------"
}

event attach createfile CreateFile
event attach showfile ReadFile

File() {

    if [[ ! -f "log.txt" ]];then
	event emit createfile "log.txt"
	return 1;
    fi

    event emit showfile "log.txt"
}

File
