#!/bin/bash



# Debian constants

export DEBIAN_FRONTEND="noninteractive"

export UPDATE="apt-get -y update"
export UPGRADE="apt-get -y dist-upgrade"
export AUTOREMOVE="apt-get -y autoremove"

export ADDREPOSITORY="add-apt-repository"
export INSTALL="apt-get -y -o Dpkg::Options::=--force-confold install"



# Linux helper functions

update() {
  echo "Running update..."
  sudo $UPDATE
}

upgrade() {
  echo "Running upgrade..."
  sudo $UPGRADE
}

autoremove() {
  echo "Running autoremove..."
  sudo $AUTOREMOVE
}

install () {
  for var in "$@"; do
    if ! packageexists "$var"; then
      echo "Installing $var..."
      sudo $INSTALL $var
    fi
  done
}

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

scan_url_install() {
  if ! packageexists "$1"; then
    INSTALL_URL=$(wget -q "$2" -O - \
    | tr "\t\r\n'" '   "' \
    | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' \
    | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' \
    | grep "$1")
    url_install "$1" "$INSTALL_URL"
  fi
}

script_install() {
  if ! packageexists "$1"; then
    echo "Installing $1..."
    sh <(curl -sSf "$2")
  fi
}




# Debian-specific helper functions

addrepository() {
  echo "Adding repository $1..."
  sudo $ADDREPOSITORY "$1"
}
repositoryexists() {
  if [[ -z $(find /etc/apt/ -name *.list | xargs cat | grep "$(echo "$1" | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')") ]]; then
    return 0 # false
  else
    return 1 # true
  fi
}
packageexists() {
  OUTPUT="$(dpkg -s "$1" 2>&1 > /dev/null)"
  if [[ -z "$OUTPUT" ]]; then
    echo "$1 is already installed"
    return 0 # true
  else
    return 1 # false
  fi
}
