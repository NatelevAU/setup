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
DOCKER_REPO="deb [arch=amd64] https://download.docker.com/linux/debian disco stable"
if repositoryexists "$DOCKER_REPO"; then
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - 
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

# Spotify
SPOTIFY_REPO="deb http://repository.spotify.com stable non-free"
if repositoryexists "$SPOTIFY_REPO"; then
  curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "$SPOTIFY_REPO" | sudo tee /etc/apt/sources.list.d/spotify.list
fi

# Teams
TEAMS_REPO="deb [signed-by=/etc/apt/keyrings/teams-for-linux.asc arch=amd64] https://repo.teamsforlinux.de/debian/ stable main"
if repositoryexists "$TEAMS_REPO"; then
  sudo mkdir -p /etc/apt/keyrings
  sudo wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc
  echo "deb [signed-by=/etc/apt/keyrings/teams-for-linux.asc arch=$(dpkg --print-architecture)] https://repo.teamsforlinux.de/debian/ stable main" \
  | sudo tee /etc/apt/sources.list.d/teams-for-linux-packages.list
fi



# Custom install functions

# Slack
install_slack() {
  if ! packageexists "slack-desktop"; then
    echo "Installing slack-desktop..."
    wget -q https://slack.com/downloads/instructions/debian -O - \
    | tr "\t\r\n'" '   "' \
    | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' \
    | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' \
    | grep 'slack-desktop' \
    | xargs wget -q -O slack-desktop.deb
    sudo $INSTALL_FILE slack-desktop.deb
    rm -rf slack-desktop.deb
  fi
}

# NVM
install_nvm() {
  if [[ ! -d "${HOME}/.nvm/.git" ]]; then
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
  fi
}

# Postman
install_postman() {
  if [[ ! -d "/opt/Postman" ]]; then
    BIT=$(getconf LONG_BIT)
    wget -O postman.tar.gz "https://dl.pstmn.io/download/latest/linux${BIT}"
    sudo tar xvf postman.tar.gz -C /opt/
    rm postman.tar.gz

    # Make the app accessible from a launcher icon 
    echo "[Desktop Entry]
    Encoding=UTF-8
    Name=Postman
    Exec=/opt/Postman/app/Postman %U
    Icon=/opt/Postman/app/resources/app/assets/icon.png
    Terminal=false
    Type=Application
    Categories=Development;" >> ~/.local/share/applications/Postman.desktop
  fi
}



# Install packages required to install some other packages
install gdebi-core



# Install setup packages
install rclone

# Install dev environment packages
install apt-transport-https
install aws-shell
install docker-ce docker-ce-cli
install git-all
install mysql-server
install postgresql postgresql-contrib
install_postman

# Install dev packages
install build-essential
install default-jre openjdk-8-jre-headless openjdk-11-jdk
install libffi-dev
install nodejs
install_nvm
install perl
install python2.7-dev
install python3-dev python3-pip

# Install communication packages
url_install discord "https://discord.com/api/download?platform=linux&format=deb"
install signal-desktop
install_slack
install teams-for-linux
install telegram-desktop
# install zoom

# Install IDE/editor packages
install code
install emacs
install gedit
install nano

# Install utility packages
install gparted # graphical disk partition editor
install keychain
install libreoffice
install nemo nemo-fileroller # file manager
install netcat
install net-tools
install pinta # like MS paint
install putty
install ssh
install tar
install tigervnc-viewer
install thunderbird
install vlc
install zip

# Install misc packages
install ffmpeg # process video/audo files
install gimp
install qbittorrent
install spotify-client

# Install games
url_install "minecraft-launcher" "https://launcher.mojang.com/download/Minecraft.deb"



# Don't require sudo for Docker
sudo groupadd docker
sudo usermod -aG docker $USER

# Run Docker on boot
# TODO Add alternative if "System has not been booted with systemd as init system (PID 1). Can't operate."
sudo systemctl enable docker
sudo systemctl start docker

# Start MySQL
sudo systemctl start mysql.service

# Setup PostgreSQL
# TODO Find better alternative
# sudo pg_ctlcluster 14 main start

# Refresh environment settings
source ~/.bashrc

# Upgrade all other packages
upgrade

# Remove any obsolete packages
autoremove

