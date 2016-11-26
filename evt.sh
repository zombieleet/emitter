#!/usr/bin/env bash

declare -A Stack

event() {

    local subcomm=$1

    case $subcomm in
	attach)

	    # total number of arguement must be exactly 3
	    [[ ! ${#@} -eq 3 ]] && {
		printf "%s\n" "Invalid Number of Arguments"
		return 1;
	    }

	    # if subcomm is attach assign the second variable as the type of the event
	    # assign the third variable as the callback to fire
	    local typeofEvent=$2

	    local messageCallback=$3


	    # checking if truy messageCallback is a function
	    declare -F ${messageCallback} >/dev/null
	    # if messageCallback is not a function return from this function
	    [[ $? -gt 0 ]] && {
		printf "%s\n" "${messageCallback} is not defined"
		return 1;
	    }

	    # assigining the event type as a key to the global Array Stack and messageCallback as it's value
	    Stack[$typeofEvent]=${messageCallback}
	    ;;
	emit)
	    # total number of argument must be less than 3

	    [[ ${#@} -lt 3 ]] && {
		printf "%s\n" "Invalid Number of Arguments"
		return 1;
	    }

	    # assign the second variable as the type of event
	    # argsToCallback contains args to be passed to the function  messageCallback inside the attach case
	    # the args should be passed like this
	          # "firstarg secondarg 'third arg'" <<< use  ' ' if the argument contains space or tabs
	          # the last two argument to the messageCallback function is the typeofEvent fired and the messageCallback function itself
	    local typeofEvent=$2
	    local argsToCallback=$3
	    read -a argsToCallback <<<${argsToCallback}
	    argsToCallback[$(( ${#argsToCallback[@]} + 1 ))]=${typeofEvent}

	    shift 2
	    for stacks in "${!Stack[@]}";do
		if [[ "$stacks" == "$typeofEvent" ]];then
		    argsToCallback[$(( ${#argsToCallback[@]} + 1 ))]=${Stack[$stacks]}
		    #echo ${argsToCallback[@]}
		    eval "${Stack[$stacks]}" "${argsToCallback[*]}"
		fi
	    done
	    ;;
	detach)
	    # Deatch ( remove ) the event type from the Stack
	    local typeofEvent=$2
	    [[ ! ${#@} -eq 2 ]] && {
		printf "%s\n" "Invalid Number of Arguments"
		return 0;
	    }
	    for stacks in "${!Stack[@]}";do
		if [[ "$stacks" == "$typeofEvent" ]];then
		    unset Stack[$stacks]
		fi
	    done
	    ;;
	*)
	    printf "%s\n" "Invalid subcommand $subcomm"
	    ;;
    esac
}
