#!/bin/bash



# URL Constants
ICONS_TARGET="$HOME/.local/share/icons/"
ICONS_SOURCE="https://raw.githubusercontent.com/adhec/plasmaX/master/PlasmaXDark/icons"

download_file() {
	sudo wget -q "$1" -P "$2"
}



download_file "$ICONS_SOURCE/audio.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/battery.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/configure.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/device.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/nepomuk.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/network.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/notification.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/preferences.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/start.svg" "$ICONS_TARGET"
download_file "$ICONS_SOURCE/system.svg" "$ICONS_TARGET"

