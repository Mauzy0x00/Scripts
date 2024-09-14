#!/bin/bash
# Author: Mauzy0x00
# Purpose: Install Hugo and its dependencies
# References:
#   https://github.com/gohugoio/hugo?tab=readme-ov-file
#   https://go.dev/doc/install
#   https://sass-lang.com/install/
#
# Notes: Edit the download links for the release versions you wish to use

# Update && upgrade system
printf "\nUpdating and upgrading system...\n"
sudo apt update && sudo apt upgrade -y

# Install Go
read -p "Is Go 1.23.1 the correct version to install? (y/n) " go_version_confirm
if [[ "$go_version_confirm" == "y" ]]; then
    printf "\nDownloading Go 1.23.1...\n"
    wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz

    printf "\nRemoving any existing Go installation and installing Go 1.23.1...\n"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz

    printf "\nAdding Go to PATH...\n"
    export PATH=$PATH:/usr/local/go/bin

    printf "\nVerifying Go installation...\n"
    go version
else
    printf "\nSkipping Go installation.\n"
fi

# Install Dart Sass
read -p "Is Dart Sass 1.78.0 the correct version to install? (y/n) " sass_version_confirm
if [[ "$sass_version_confirm" == "y" ]]; then
    printf "\nDownloading Dart Sass 1.78.0...\n"
    wget https://github.com/sass/dart-sass/releases/download/1.78.0/dart-sass-1.78.0-linux-x64.tar.gz

    printf "\nInstalling Dart Sass...\n"
    sudo tar -C /usr/local -xzf dart-sass-1.78.0-linux-x64.tar.gz

    printf "\nAdding Dart Sass to PATH...\n"
    export PATH=$PATH:/usr/local/dart-sass

    printf "\nVerifying Dart Sass installation...\n"
    sass --version
else
    printf "\nSkipping Dart Sass installation.\n"
fi

# Clean up
printf "\nCleaning up downloaded files...\n"
rm go1.23.1.linux-amd64.tar.gz dart-sass-1.78.0-linux-x64.tar.gz

# Install Hugo
read -p "Do you want to build and install Hugo with the extended edition? (y/n) " hugo_confirm
if [[ "$hugo_confirm" == "y" ]]; then
    printf "\nBuilding and installing Hugo extended edition...\n"
    CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest

    printf "\nAdding Hugo to PATH...\n"
    export PATH=$PATH:~/go/bin

    printf "\nVerifying Hugo installation...\n"
    hugo version
else
    printf "\nSkipping Hugo installation.\n"
fi

printf "\nInstallation complete!\n"  