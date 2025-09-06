#!/usr/bin/env bash

source ../utils.sh

sudo dnf update -y

print "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc

print "Install Node 22 and global packages"
nvm install 22
nvm use 22
npm install --global nx @angular/cli firebase-tools aws-cdk ts-node prettier

print "Install Golang"

curl -LO https://dl.google.com/go/go1.24.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.24.5.linux-amd64.tar.gz
source ~/.bashrc
rm -rf go1.24.5.linux-amd64.tar.gz

print "Install Make"
sudo dnf install -y make

print "Install GitFlow"
curl --silent --location  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/master/contrib/gitflow-installer.sh --output ./gitflow-installer.sh
sudo bash gitflow-installer.sh install develop
rm gitflow-installer.sh
sudo rm -rf gitflow

print "Install compilers"
sudo dnf install -y gcc gcc-c++ python3-devel