#!/usr/bin/env bash

declare -A Stack
declare -i _MAXLISTENER_=11
event() {

    local subcomm=$1

    
    case $subcomm in
	attach)

	    # total number of arguement must be exactly 3
	    [[ ! ${#@} -eq 3 ]] && {
		throw error "Invalid Number of Arguments to $subcomm"
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
	    
	    {
		[[ ${#Stack[@]} -eq ${_MAXLISTENER_} ]] || [[ ${#Stack[@]} -gt ${_MAXLISTENER_} ]]
		
	    } && {
		throw error "Number of listeners exceeded, use setMaxlisteners subcommand to increment the amount of listeners"
	    }

	    # assigining the event type as a key to the global Array Stack and messageCallback as it's value
	    Stack[$typeofEvent]=${messageCallback}
	    ;;
	emit)
	    # total number of argument must not be less than 2
	    
	    [[ ${#@} -lt 2 ]] && {
		throw error "Invalid Number of Arguments to $subcomm"
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
		    eval ${Stack[$stacks]} "${argsToCallback[*]}"
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
		throw error "Invalid Number of Arguments to $subcomm"
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
	once)
	    # total number of argument must not be less than 2
	    
	    [[ ${#@} -lt 2 ]] && {
		throw error "Invalid Number of Arguments to $subcomm"
	    }
	    
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
		    eval ${Stack[$stacks]} "${argsToCallback[*]}"
		    unset Stack[$stacks]; 
		    break
		}
	    done

	    [[ $? -gt 0 ]] && {
		throw error "cannot emit ${typeofEvent} because it has not been registerd as a listener"
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
	removeAll)
	    unset Stack
	    ;;
	setMaxListener)
	    
	    [[ ! ${#@} -eq 2 ]] && {
		throw error "$subcomm requires only one argument"
	    }
	    
	    local num=${2}
	    
	    [[ ! ${num} =~ ^[[:digit:]]{1,}$ ]] && {
		throw error "the argument to $subcomm must be an integer"
	    }

	    _MAXLISTENER_=${num}
	    
	    ;;
	*)
	    throw error "\" $subcomm \" is not a valid subcommand"
	    ;;
    esac
}


throw() {
    local subComm="${1}"
    local message="${2}"
    local open="\e["
    local close="\e[0m"
    local bold="1;"
    local light="0;"
    local red="31m"
    local yellow="33m"
    
    case $subComm in
	error)
	    
	    
	    [[ -z ${message} ]] && {
                #${FUNCNAME[$(( ${#FUNCNAME[@]} - $(( ${#FUNCNAME[@]} - 2 )) ))]} ,
		#  to get the calling function, when you do a - 1 it gives 
		#   the source builtin command as the calling function,
		#     so we have to minus by 2
		message="An Error has occured in ${FUNCNAME[$(( ${#FUNCNAME[@]} - 2))]}"
	    }
	    printf "${open}${bold}${red}%s${close}\n" "${message}"
	    
	    ;;
	warning)
	    [[ -z ${message} ]] && {
		message="An Error has occured in ${FUNCNAME[$(( ${#FUNCNAME[@]} - 2))]}"
	    }
	    printf "${open}${bold}${yellow}%s${close}\n" "${message}"
	    ;;
	*)
	    ${FUNCNAME} error "Invalid Arugment was passed to ${FUNCNAME}"
	    ;;
    esac
    exit 1;
}

