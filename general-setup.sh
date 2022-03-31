#!/bin/bash
export UTIL="https://raw.githubusercontent.com/NatelevAU/setup/main/util/util.sh"
bash <(curl -s "$UTIL")

# setup.sh - bash script to set up a new environment



# General setup function to check which OS is running
general_setup() {
	
	echo "OSTYPE is $OSTYPE"
	case "$OSTYPE" in
		linux-gnu*) run_file "$LINUX_SETUP_PATH" ;; # Linux
		cygwin*) ;; # POSIX compatibility layer and Linux environment emulation for Windows
		msys*) ;; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
		win32*) ;; # Windows
		darwin*) ;; # Mac OSX
		freebsd*) ;; # FreeBSD
		solaris*) ;; # Solaris
		*) echo "Unknown ostype: $OSTYPE" ;; # DEFAULT
	esac
}



# Helper functions

run_file() {
	bash <(curl -s "$1")
}
export -f run_file



general_setup

