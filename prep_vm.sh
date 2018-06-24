#!/bin/bash

branch="google_cloud"
giturl="https://github.com/yigewu/gatk4wxscnv.git"
mainDir="/home/yigewu2012/"

#Set up repository
## Update the apt package index:
sudo apt-get update
## Uninstall old versions
sudo apt-get remove docker docker-engine docker.io
## Install packages to allow apt to use a repository over HTTPS:
yes | sudo apt-get install apt-transport-https ca-certificates curl software-properties-common gnupg2
## Add Docker’s official GPG key:
yes | curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
## Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88
## Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or test repositories as well. To add the edge or test repository, add the word edge or test (or both) after the word stable in the commands below.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

#install docker community version
## Update the apt package index.
sudo apt-get update
## Install the latest version of Docker CE, or go to the next step to install a specific version:
sudo apt-get install docker-ce
sudo usermod -a -G docker ${USER}

## git clone scripts
cd ${mainDir}
git clone -b ${branch} ${giturl}

echo "make sure there's sufficient disk space for bams!"

exit
