#!/bin/bash

# This script automates package management tasks on Debian-based systems.
# It includes functions for updating, upgrading, cleaning up the system,
# adding repositories, and installing packages.

# Debian constants

# Set noninteractive frontend to avoid interactive prompts during automated operations.
export DEBIAN_FRONTEND="noninteractive"

# Define commands for updating package lists, upgrading packages, and cleaning up unnecessary packages.
export UPDATE="apt-get -y update"
export UPGRADE="apt-get -y dist-upgrade"
export AUTOREMOVE="apt-get -y autoremove"

# Commands for adding new repositories and installing packages with specific options.
export ADDREPOSITORY="add-apt-repository"
export INSTALL="apt-get -y -o Dpkg::Options::=--force-confold install"

# Debian helper functions

# Updates the package list using apt-get.
update() {
  echo "Running update..."
  sudo $UPDATE
}

# Upgrades all the packages on the system.
upgrade() {
  echo "Running upgrade..."
  sudo $UPGRADE
}

# Removes packages that are no longer needed.
autoremove() {
  echo "Running autoremove..."
  sudo $AUTOREMOVE
}

# Checks if a repository exists in the system's sources list.
repositoryexists() {
  if [[ -z $(find /etc/apt/ -name *.list | xargs cat | grep "$(echo "$1" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')") ]]; then
    return 0 # false
  else
    return 1 # true
  fi
}

# Checks if a package is already installed on the system.
packageexists() {
  OUTPUT="$(dpkg -s "$1" 2>&1 > /dev/null)"
  if [[ -z "$OUTPUT" ]]; then
    echo "$1 is already installed"
    return 0 # true
  else
    return 1 # false
  fi
}

# Adds a new repository to the system's sources list.
addrepository() {
  echo "Adding repository $1..."
  sudo $ADDREPOSITORY "$1"
}

# Installs a list of packages passed as arguments.
# Skips installation if the package is already installed.
install () {
  for var in "$@"; do
    if ! packageexists "$var"; then
      echo "Installing $var..."
      sudo $INSTALL $var
    fi
  done
}

# Installs a package from a specified URL.
# Downloads the .deb file and installs it.
url_install() {
  if ! packageexists "$1"; then
    echo "Installing $1..."
    TMP_DIR=$(mktemp -d)
    FILENAME="$TMP_DIR/$1.deb"
    wget -q "$2" -O "$FILENAME"
    sudo $INSTALL "$FILENAME"
    rm -rf "$TMP_DIR"
  fi
}

# Scans a URL for a specific pattern to find a download link,
# then calls `url_install` to install the package.
scan_url_install() {
  if ! packageexists "$1"; then
    INSTALL_URL=$(wget -q "$3" -O - \
    | tr "\t\r\n'" '   "' \
    | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' \
    | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' \
    | grep "$2")
    url_install "$1" "$INSTALL_URL"
  fi
}

# Installs a package by downloading and executing a script from a URL.
script_install() {
  if ! packageexists "$1"; then
    echo "Installing $1..."
    curl -o- "$2" | bash
  fi
}

# Note: This script is intended to be sourced in other scripts for utility functions,
# not executed directly.
