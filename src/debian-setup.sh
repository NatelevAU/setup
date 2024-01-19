#!/bin/bash



# Path Constants

CURR_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DEBIAN_HELPER_PATH="$CURR_DIR/debian-helper.sh"
DEBIAN_PACKAGES_PATH="$CURR_DIR/debian-packages.sh"

source "$DEBIAN_HELPER_PATH"



# Update repositories
update



# Check sudo is installed
install sudo

# Add user to sudo list if not running with root permissions
if [[ "$EUID" -ne 0 ]]; then
  echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
fi

# Install SSH keys
# TODO: Generate/install automatically
read -p 'You should add your SSH keys. Press any key to continue...'

# Install dotfiles
# TODO: Setup automatically
read -p 'You should setup your dotfiles. Press any key to continue...'



# Setup packages
source "$DEBIAN_PACKAGES_PATH"

