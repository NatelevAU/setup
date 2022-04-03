#!/bin/bash



# Path Constants

CURR_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
UBUNTU_HELPER_PATH="$CURR_DIR/ubuntu-helper.sh"
UBUNTU_PACKAGES_PATH="$CURR_DIR/ubuntu-packages.sh"

source "$UBUNTU_HELPER_PATH"



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
source "$UBUNTU_PACKAGES_PATH"

