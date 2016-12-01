#!/usr/bin/env bash

declare -A Stack

event() {
    source throw.bash
    local subcomm=$1

    
    case $subcomm in
	attach)

	    # total number of arguement must be exactly 3
	    [[ ! ${#@} -eq 3 ]] && {
		throw error "Invalid Number of Arguments $subcomm"
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
		throw error "${messageCallback} is not defined"
		return 1;
	    }

	    # assigining the event type as a key to the global Array Stack and messageCallback as it's value
	    Stack[$typeofEvent]=${messageCallback}
	    ;;
	emit)
	    # total number of argument must not be less than 2

	    [[ ${#@} -lt 2 ]] && 
		throw error "Invalid Number of Arguments $subcomm"
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

	    # if there is not listener in the stack, throw an error
	    [[ ${#Stack[@]} -eq 0 ]] && {
		throw error "There is no listener in the stack to emit"
	    }

	    
	    for stacks in "${!Stack[@]}";do
		[[ "$stacks" == "$typeofEvent" ]] && {
		    argsToCallback[$(( ${#argsToCallback[@]} + 1 ))]=${Stack[$stacks]}
		    eval "${Stack[$stacks]}" "${argsToCallback[*]}"
		    break
		}
	    done

	    [[ $? -gt 0 ]] && {
		throw error "cannot emit ${typeofEvent} because it has not been registerd as a listener"
	    }

	    ;;
	detach)
	    # Deatch ( remove ) the event type from the Stack
	    local typeofEvent=$2
	    [[ ! ${#@} -eq 2 ]] && {
		throw error "Invalid Number of Arguments $subcomm"
	    }
	    
	    for stacks in "${!Stack[@]}";do
		
		[[ "$stacks" == "$typeofEvent" ]] && {
		    unset Stack[$stacks]
		    break 
		}
		
	    done
	    
	    [[ $? -gt 0 ]] && {
		throw error "cannot detach ${typeofEvent} because it has not been registerd as a listener"
	    }

	    ;;
	list)
	    [[ ${#Stack[@]} -eq 0 ]] && {
		throw error "There is no listener in the stack"
	    }
	    for stacks in "${!Stack[@]}";do
		printf "%s\n" "${stacks}"
	    done
	    ;;
	*)
	    throw error "%s\n" "Invalid subcommand $subcomm"
	    ;;
    esac
}
s() {
    echo "hi"
}
event attach Say s
event attach Vic s
event emit Say
event emit Vic

#event detach Say

#event list

event emit Q
event detach Q
