#!/bin/bash



# General setup function for linux
linux_setup() {
	LINUX_ID=$(cat /etc/*-release | grep "^ID=" | sed 's/ID=//')
	LINUX_ID_LIKE=$(cat /etc/*-release | grep "^ID_LIKE=" | sed 's/ID_LIKE=//')
	LINUX_VERSION_ID=$(cat /etc/*-release | grep "^VERSION_ID=" | sed 's/VERSION_ID=//')
	
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

