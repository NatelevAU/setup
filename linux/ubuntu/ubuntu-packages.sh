#!/bin/bash



# Install packages required to add custom repositories
install apt-utils ca-certificates curl gpg libssl-dev software-properties-common wget



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
install nemo nemo-fileroller # file manager
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
url_install "minecraft-launcher" "https://launcher.mojang.com/download/Minecraft.deb"
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
sudo pg_ctlcluster 14 main start

# Upgrade npm
sudo npm install -g npm

# Setup Yarn
sudo npm i -g yarn

# Upgrade all other packages
upgrade

# Remove any obsolete packages
autoremove

