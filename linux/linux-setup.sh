#!/bin/bash



# General setup function for linux

linux_setup() {
	echo "Starting setup..."

	# System variables
	export LANGUAGE=C.UTF-8
	export LANG=C.UTF-8
	export LC_ALL=C.UTF-8

	# Set up variables
	export LINUX_ID=$(cat /etc/*-release | grep "^ID=" | sed 's/ID=//')
	export LINUX_ID_LIKE=$(cat /etc/*-release | grep "^ID_LIKE=" | sed 's/ID_LIKE=//')
	export LINUX_VERSION_ID=$(cat /etc/*-release | grep "^VERSION_ID=" | sed 's/VERSION_ID=//')
	
	echo "Running on $LINUX_ID $LINUX_VERSION_ID (like $LINUX_ID_LIKE)"
	run_file "$LINUX_SETUP_PATH"
	
	case "$LINUX_ID" in
		ubuntu*) run_file "$UBUNTU_SETUP_PATH" ;;
		# debian*) ;;
		# arch*) ;;
		*) echo "Unknown distro $ID like $ID_LIKE" ;; # DEFAULT
	esac
}



linux_setup

