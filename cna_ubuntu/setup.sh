#!/bin/bash

set -euo pipefail

# set vim as git's default editor
git config --global core.editor "vim"

sudo apt-get update && sudo apt-get install -y curl vim unzip

GOPATH="$HOME/development/go"
mkdir -p "$GOPATH"

LIBS="$HOME/libs"
mkdir -p "$LIBS"

# install golang
echo "Installing golang..."
curl -o "$LIBS"/go.tar.gz https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
cd "$LIBS" && tar xzvf "$LIBS"/go.tar.gz
export GOROOT="$LIBS"/go
echo GOROOT="$GOROOT"

# install docker
echo "Installing docker..."
curl -sSL https://get.docker.com/ | sh && \
curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz && \
tar --strip-components=1 -xvzf docker-1.11.2.tgz -C /usr/bin &&  \
mv /usr/bin/docker /usr/bin/docker1.11 && \
curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz && \
tar --strip-components=1 -xvzf docker-1.12.6.tgz -C /usr/bin  && \
mv /usr/bin/docker /usr/bin/docker1.12 && \
curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-1.13.0.tgz && \
tar --strip-components=1 -xvzf docker-1.13.0.tgz -C /usr/bin && \
mv /usr/bin/docker /usr/bin/docker1.13 && \
ln -s /usr/bin/docker1.13 /usr/bin/docker

# install drone
echo "Installing drone"
curl http://downloads.drone.io/release/linux/amd64/drone.tar.gz | tar zx && \
    sudo install -t /usr/local/bin drone

# install govc
echo "Installing govc"
curl -sSL https://github.com/vmware/govmomi/releases/download/v0.14.0/govc_linux_amd64.gz | gzip -d | sudo tee /usr/local/bin/govc 1> /dev/null && \
    sudo chmod +x /usr/local/bin/govc

# install zsh
sudo apt-get install -y zsh && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install ansible
sudo apt-get install -y software-properties-common && \
  apt-add-repository ppa:ansible/ansible && \
  apt-get update && \
  apt-get install -y ansible

# install packer
curl -lo packer.zip https://releases.hashicorp.com/packer/1.0.2/packer_1.0.2_linux_amd64.zip
unzip packer.zip
sudo chmod +x packer
sudo mv packer /usr/local/bin/packer

# install gsutil
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get install -y google-cloud-sdk
gcloud init

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo 'execute pathogen#infect()' >> ~/.vimrc

# install vim-go
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
