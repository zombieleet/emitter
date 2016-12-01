#!/usr/bin/env bash

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
