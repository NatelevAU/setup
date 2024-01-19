#!/bin/bash
# General setup function for linux


# Path Constants

CURR_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DEBIAN_SETUP_PATH="$CURR_DIR/debian-setup.sh"
LINUX_ENVIRONMENT_PATH="$CURR_DIR/linux-environment.sh"



# Check which linux distro is running
linux_setup() {
	echo "Starting setup..."

	# System variables
	export LANGUAGE=C.UTF-8
	export LANG=C.UTF-8
	export LC_ALL=C.UTF-8

	# Set up variables
	export LINUX_ID=$(cat /etc/*-release | grep "^ID=" | sed 's/ID=//')
	export LINUX_VERSION_ID=$(cat /etc/*-release | grep "^VERSION_ID=" | sed 's/VERSION_ID=//' | sed 's/"//g')
	export LINUX_ID_LIKE=$(cat /etc/*-release | grep "^ID_LIKE=" | sed 's/ID_LIKE=//')
	LINUX_DISTRO_NAME="$LINUX_ID $LINUX_VERSION_ID"
	if [[ ! -z "$LINUX_ID_LIKE" ]]; then
		LINUX_DISTRO_NAME="$LINUX_DISTRO_NAME (like $LINUX_ID_LIKE)"
	fi
	echo "Running on $LINUX_DISTRO_NAME"
	
	case "$LINUX_ID" in
		ubuntu*) source "$DEBIAN_SETUP_PATH" ;;
		debian*) source "$DEBIAN_SETUP_PATH" ;;
		# arch*) ;;
		*) echo "Unknown distro $LINUX_DISTRO_NAME" ;; # DEFAULT
	esac
	
	# Setup environment
	source "$LINUX_ENVIRONMENT_PATH"

	echo "Setup finished!"
}



linux_setup

