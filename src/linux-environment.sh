#!/bin/bash



CURR_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_DIR="$CURR_DIR/environment"

# URL Constants
PLASMAX_TARGET="$HOME/.local"
PLASMAX_SOURCE="$ENV_DIR/share"

copy_files () {
	echo "test"
	# sudo cp -r "$1" "$2"
}

# Install PlasmaX
copy_files "$PLASMAX_SOURCE" "$PLASMAX_TARGET"

