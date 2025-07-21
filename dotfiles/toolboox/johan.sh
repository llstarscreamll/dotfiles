#!/usr/bin/env bash

sudo dnf update -y

echo "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc

echo "Install Node 22 and global packages"
nvm install 22
nvm use 22
npm install --global nx @angular/cli firebase-tools aws-cdk

echo "Install Golang"

curl -LO https://dl.google.com/go/go1.24.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.24.5.linux-amd64.tar.gz
source ~/.bashrc
rm -rf go1.24.5.linux-amd64.tar.gz

echo "Install Make"
sudo dnf install -y make