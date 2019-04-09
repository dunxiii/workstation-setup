#!/usr/bin/env bash

set -au

install_packages+=(
    NetworkManager-openconnect-gnome
    blueman
    curl
    dconf-editor
    docker-ce
    git
    gnome-tweaks
    google-chrome-stable
    gpick
    htop
    libgnome-keyring
    nextcloud-client
    nextcloud-client-nautilus
    nmap
    pwgen
    python-unversioned-command
    python3-virtualenv
    ranger
    remmina
    snapd
    transmission
    unar
    vim
    xclip
)

# nVidia driver from RPM Fusion
if grep -i nvidia <(lspci); then
    install_packages+=(
        akmod-nvidia
        xorg-x11-drv-nvidia
    )
fi

# vscode snap does not work any good
snap_packages+=(
    'code --classic'
    spotify
    vlc
)

# Make sure script is run as root
if [ ${UID} -ne 0 ]; then
    echo "Run this script as root" 1>&2
    exit 2
fi

# Enable google chrome repo
dnf install fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome

grep -i nvidia <(lspci) && \
    dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver

# Repo for docker
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Updates each package to the latest version that is both available and resolvable
dnf upgrade

# Install extra packages
dnf install "${install_packages[@]}"

# Remove old dependencies
dnf autoremove

# Snap with --classic fix
ln -s /var/lib/snapd/snap /snap

# Install snap packages
for snap in "${snap_packages[@]}"; do
    snap install ${snap}
done

echo "Good gnome extentions to install:"
echo "- Argos"
echo "- Clipboard Indicator"
echo "- Dash to Panel"
echo "- No Topleft Hot Corner"
echo "- Refresh wifi connections"
echo "- Sound Input & Output Device Chooser"
echo "- Top Panel Workspace Scroll"
echo "- Topicons plus"
