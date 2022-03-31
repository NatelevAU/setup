#!/bin/bash



util() {
	set_constants
}



# URL constants

set_constants() {
	export UTIL="https://raw.githubusercontent.com/NatelevAU/setup/main/util/util.sh"

	export LINUX_SETUP_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/linux-setup.sh"
	
	export UBUNTU_SETUP_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-setup.sh"
	export UBUNTU_HELPER_PATH="https://raw.githubusercontent.com/NatelevAU/setup/main/linux/ubuntu/ubuntu-helper.sh"
}



# Helper functions

export run_file() {
	wget -qO- "$1" | sudo bash
}



util

