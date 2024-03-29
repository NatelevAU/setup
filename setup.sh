#!/bin/bash
# setup.sh - bash script to set up a new environment



# Path Constants

CURR_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LINUX_SETUP_PATH="$CURR_DIR/src/linux-setup.sh"



# Setup function to check which OS is running
setup() {
	echo "OSTYPE is $OSTYPE"
	case "$OSTYPE" in
		linux-gnu*) source "$LINUX_SETUP_PATH" ;; # Linux
		cygwin*) ;; # POSIX compatibility layer and Linux environment emulation for Windows
		msys*) ;; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
		win32*) ;; # Windows
		darwin*) ;; # Mac OSX
		freebsd*) ;; # FreeBSD
		solaris*) ;; # Solaris
		*) echo "Unknown ostype: $OSTYPE" ;; # DEFAULT
	esac
}



setup

