#!/bin/bash



# URL constants

export UTIL="https://raw.githubusercontent.com/NatelevAU/setup/main/util/util.sh"

export LINUX_SETUP_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/linux-setup.sh"

export UBUNTU_SETUP_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-setup.sh"
export UBUNTU_HELPER_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-helper.sh"



# Helper functions

run_file() {
	bash <(curl -s "$1")
}

echo "test"



export -f run_file

