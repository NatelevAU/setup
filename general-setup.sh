#!/bin/bash
# setup.sh - bash script to set up a new environment



# URL Constants

export LINUX_SETUP_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/linux-setup.sh"

export UBUNTU_SETUP_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-setup.sh"
export UBUNTU_HELPER_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-helper.sh"




# Helper functions

run_file() {
	wget -qO- "$1" | sudo bash
}



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



general_setup

