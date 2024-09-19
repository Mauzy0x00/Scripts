#!/bin/bash
# Author: Mauzy0x00
# Purpose: Install Hugo and its dependencies
# References:
#   https://github.com/gohugoio/hugo?tab=readme-ov-file
#   https://go.dev/doc/install
#   https://sass-lang.com/install/
#   https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path
#
# Notes: Edit the download links for the release versions you wish to use. 

# Update && upgrade system
printf "\nUpdating and upgrading system...\n"
sudo apt update && sudo apt upgrade -y

# Install GCC & G++
sudo apt install gcc g++

# Install Go
printf "\n\n"
read -p "Is Go 1.23.1 the correct version to install? (y/n) " go_version_confirm
if [[ "$go_version_confirm" == "y" ]]; then
    printf "\n\nDownloading Go 1.23.1..."
    wget https://go.dev/dl/go1.23.1.linux-amd64.tar.gz

    printf "\nRemoving any existing Go installation and installing Go 1.23.1...\n"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz

    printf "\nAdding Go to PATH...\n"
    echo 'PATH=$PATH:/usr/local/go/bin' >> ~/.profile
    source ~/.profile

    printf "\nSetting GOPATH to ~/.go ...\n"
    mkdir ~/.go
    go env -w GOPATH=~/.go
    printf "GOPATH set to: "
    go env GOPATH
    #echo 'GOPATH=~/.go' >> ~/.profile

    printf "\n\nVerifying Go installation...\n"
    source ~/.profile
    go version

    printf "--------------------------------------------------------------"
else
    printf "\n\nSkipping Go installation.\n"
fi

# Install Dart Sass
printf "\n\n"
read -p "Is Dart Sass 1.78.0 the correct version to install? (y/n) " sass_version_confirm
if [[ "$sass_version_confirm" == "y" ]]; then
    printf "\n\nDownloading Dart Sass 1.78.0...\n"
    wget https://github.com/sass/dart-sass/releases/download/1.78.0/dart-sass-1.78.0-linux-x64.tar.gz

    printf "Installing Dart Sass...\n"
    sudo tar -C /usr/local -xzf dart-sass-1.78.0-linux-x64.tar.gz

    printf "\nAdding Dart Sass to PATH...\n"
    echo 'PATH=$PATH:/usr/local/dart-sass' >> ~/.profile

    printf "\n\nVerifying Dart Sass installation...\n"
    source ~/.profile
    sass --version
else
    printf "\n\nSkipping Dart Sass installation.\n"
fi

# Clean up
printf "\n\nCleaning up downloaded files...\n"
rm go1.23.1.linux-amd64.tar.gz dart-sass-1.78.0-linux-x64.tar.gz

printf "--------------------------------------------------------------"


# Install Hugo
printf "\n\n"
read -p "Do you want to build and install Hugo with the extended edition? (y/n) " hugo_confirm
if [[ "$hugo_confirm" == "y" ]]; then
    printf "\n\nBuilding and installing Hugo extended edition...\n"
    CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest

    printf "\nAdding Hugo to PATH...\n"
    #echo 'PATH=$PATH:~/.go/bin' >> ~/.profile
    #source ~/.profile

    printf "\nVerifying Hugo installation...\n"
    hugo version
else
    printf "\n\nSkipping Hugo installation.\n"
fi

printf "\n\nInstallation complete!\n"  