#!/usr/bin/env bash

source ../emitter.sh


readFile() {
    local text=$1
    local num=$2

    printf "%s\n" "${text} ${num}"
}


# Attaching event to the stack
event attach fileRead readFile
i=1;
while read line;do
    # emiting the event
    event emit fileRead "'$line' $i"
    : $((i++))
done < "test1.txt"

# detaching the event from the stack
event detach fileRead


while read line;do
    # event is not emmited since fileRead is not among the stack anymore
    event emit fileRead "'$line' $i"
    : $((i++))
done < "test1.txt"
