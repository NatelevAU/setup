#!/bin/bash



echo "Starting setup..."

# System variables
export LANGUAGE=C.UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8


# Set up variables
UPDATE="apt-get -y update"
INSTALL="apt-get -y -o Dpkg::Options::=--force-confold install"
UPGRADE="apt-get -y dist-upgrade"
AUTOREMOVE="apt-get -y autoremove"
ADDREPOSITORY="add-apt-repository"
SNAP_INSTALL="sudo snap install --classic"

# Remove duplicate configurations to avoid repository update warnings
# TODO Figure out why this is necessary
sudo rm -rf /etc/apt/sources.list.d/google.list


# Check sudo is installed
$UPDATE
$INSTALL sudo

# Add user to sudo list if not running with root permissions
if [[ "$EUID" -ne 0 ]]; then
  echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
fi

# Set up functions
packageexists() {
  OUTPUT="$(dpkg -s "$1" 2>&1 > /dev/null)"
  if [[ -z "$OUTPUT" ]]; then
    echo "$1 is already installed"
    return 0 # true
  else
    return 1 # false
  fi
}
install () {
  for var in "$@"; do
    if ! packageexists "$var"; then
      echo "Installing $var..."
      sudo DEBIAN_FRONTEND=noninteractive $INSTALL $var
    fi
  done
}
snap_install() {
  for var in "$@"; do
    echo "Installing $var..."
    $SNAP_INSTALL $var
  done
}
url_install() {
  if ! packageexists "$1"; then
    wget -q "$2"
    FILENAME=$(basename "$var")
    dpkg -i "$FILENAME"
    rm -rf "$FILENAME"
  fi
}
update() {
  echo "Running update..."
  sudo DEBIAN_FRONTEND=noninteractive $UPDATE
}
upgrade() {
  echo "Running upgrade..."
  sudo DEBIAN_FRONTEND=noninteractive $UPGRADE
}
autoremove() {
  echo "Running autoremove..."
  sudo DEBIAN_FRONTEND=noninteractive $AUTOREMOVE
}
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

# Install SSH keys
# TODO: Generate/install automatically
read -p 'You should add your SSH keys. Press any key to continue...'

# Install dotfiles
# TODO: Setup automatically
read -p 'You should setup your dotfiles. Press any key to continue...'



# Install packages required to add custom repositories
install apt-utils ca-certificates curl gpg libssl-dev software-properties-common wget

# Set locale
# echo "$LOCALE" > "/etc/default/locale"
# TODO Figure out what this is



# Add custom repositories

# Code
CODE_REPO="deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main"
if repositoryexists "$CODE_REPO"; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c "echo $CODE_REPO > /etc/apt/sources.list.d/vscode.list"
  rm -f packages.microsoft.gpg
fi

# Docker
DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
if repositoryexists "$DOCKER_REPO"; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
  echo "$DOCKER_REPO" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
fi

# Google Chrome
CHROME_REPO="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
if repositoryexists "$CHROME_REPO"; then
  echo "$CHROME_REPO" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo chmod +x /usr/local/bin/docker-compose
fi

# Node
# sudo curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# TODO Find better way to install node

# PostgreSQL
POSTGRESQL_REPO="deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main"
if repositoryexists "$POSTGRESQL_REPO"; then
  sudo sh -c "echo $POSTGRESQL_REPO > /etc/apt/sources.list.d/pgdg.list"
  wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
fi

# Signal
SIGNAL_REPO="deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main"
if repositoryexists "$SIGNAL_REPO"; then
  wget -qO- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
  echo "$SIGNAL_REPO" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
fi



# Install packages required to install some other packages
install gdebi-core snapd



# Install setup packages
install rclone

# Install dev environment packages
install apt-transport-https
install aws-shell
install docker-ce docker-ce-cli
install gdb
install git-all
install gradle
install maven
install netcat
install net-tools
install putty
install ssh
install tigervnc-viewer

# Install dev packages
install build-essential
install default-jre openjdk-8-jre-headless
install libffi-dev
install nodejs
install perl
install php php-cli
install postgresql postgresql-contrib
install python2.7-dev
install python3-dev python3-pip
install ruby

# Install communication packages
snap_install discord
install signal-desktop
snap_install slack
snap_install skype
# install teams
# install zoom

# Install IDE/editor packages
install code
install emacs
install gedit
snap_install intellij-idea-community
install nano

# Install utility packages
install gparted
install keychain
install libreoffice
install net-tools
install pinta
install tar
install thunderbird
install vlc
install zip

# Install misc packages
install bash-doc
install ffmpeg
install qbittorrent

# Install games
url_install "mmrdesktop" "https://github.com/mmrteam/mmr-desktop/releases/download/v1.3.0/mmrdesktop_1.3.0_amd64.deb"




# Don't require sudo for Docker
sudo groupadd docker
sudo usermod -aG docker $USER

# Run Docker on boot
# TODO Add alternative if "System has not been booted with systemd as init system (PID 1). Can't operate."
sudo systemctl enable docker
sudo systemctl start docker

# Setup PostgreSQL
# TODO Find better alternative
pg_ctlcluster 14 main start

# Setup Yarn
sudo npm i -g yarn

# Upgrade all other packages
upgrade

# Remove any obsolete packages
autoremove

echo "Setup finished!"
