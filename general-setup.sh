#!/bin/bash

# setup.sh - bash script to set up a new environment



# Main function to check which OS is running
main() {
	echo "OSTYPE is $OSTYPE"
	case "$OSTYPE" in
		linux-gnu*) linux_setup ;; # Linux
		cygwin*) ;; # POSIX compatibility layer and Linux environment emulation for Windows
		msys*) ;; # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
		win32*) ;; # Windows
		darwin*) ;; # Mac OSX
		freebsd*) ;; # FreeBSD
		solaris*) ;; # Solaris
		*) echo "Unknown ostype: $OSTYPE" ;; # DEFAULT
	esac
}



# General setup function for linux
linux_setup() {
	LINUX_ID=$(cat /etc/*-release | grep "^ID=" | sed 's/ID=//')
	LINUX_ID_LIKE=$(cat /etc/*-release | grep "^ID_LIKE=" | sed 's/ID_LIKE=//')
	LINUX_VERSION_ID=$(cat /etc/*-release | grep "^VERSION_ID=" | sed 's/VERSION_ID=//')
	
	echo "Running on $LINUX_ID (like $LINUX_ID_LIKE)"
	wget -qO- "$LINUX_SETUP_URL" | sudo bash # Run general linux setup
	
	case "$LINUX_ID" in
		ubuntu*) ubuntu_setup ;;
		# debian*) ;;
		# arch*) ;;
		*) echo "Unknown distro $ID like $ID_LIKE" ;; # DEFAULT
	esac
}

# Setup function for Ubuntu distro
ubuntu_setup() {
	wget -qO- "$UBUNTU_SETUP_URL" | sudo bash
}



# Constants
LINUX_SETUP_URL="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/linux-setup.sh"
UBUNTU_SETUP_URL="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-setup.sh"



main

