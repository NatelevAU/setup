#!/bin/bash



# Ubuntu constants

export UPDATE="DEBIAN_FRONTEND=noninteractive apt-get -y update"
export UPGRADE="DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade"
export AUTOREMOVE="DEBIAN_FRONTEND=noninteractive apt-get -y autoremove"

export ADDREPOSITORY="DEBIAN_FRONTEND=noninteractive add-apt-repository"
export INSTALL="DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=--force-confold install"
export INSTALL_FILE="DEBIAN_FRONTEND=noninteractive dpkg -i"
export SNAP_INSTALL="DEBIAN_FRONTEND=noninteractive sudo snap install --classic"



# Linux helper functions

export update() {
  echo "Running update..."
  sudo $UPDATE
}
export upgrade() {
  echo "Running upgrade..."
  sudo $UPGRADE
}
export autoremove() {
  echo "Running autoremove..."
  sudo $AUTOREMOVE
}
export install () {
  for var in "$@"; do
    if ! packageexists "$var"; then
      echo "Installing $var..."
      sudo $INSTALL $var
    fi
  done
}
export url_install() {
  if ! packageexists "$1"; then
    wget -q "$2"
    FILENAME=$(basename "$var")
    $INSTALL_FILE $FILENAME
    rm -rf "$FILENAME"
  fi
}



# Debian-specific helper functions

export addrepository() {
  echo "Adding repository $1..."
  sudo $ADDREPOSITORY "$1"
}
export repositoryexists() {
  if [[ -z $(find /etc/apt/ -name *.list | xargs cat | grep "$(echo "$1" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')") ]]; then
    return 0 # false
  else
    return 1 # true
  fi
}
export packageexists() {
  OUTPUT="$(dpkg -s "$1" 2>&1 > /dev/null)"
  if [[ -z "$OUTPUT" ]]; then
    echo "$1 is already installed"
    return 0 # true
  else
    return 1 # false
  fi
}



# Ubuntu-specific helper functions
export snap_install() {
  for var in "$@"; do
    echo "Installing $var..."
    $SNAP_INSTALL $var
  done
}

