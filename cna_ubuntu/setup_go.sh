#!/bin/bash

set -euo pipefail

GOVERSION="1.9.2"
# set vim as git's default editor
git config --global core.editor "vim"
sudo apt-get update && sudo apt-get install -y curl vim unzip

GOPATH="$HOME/development/go"
mkdir -p "$GOPATH"

LIBS="$HOME/libs"
mkdir -p "$LIBS"

# install golang
echo "Installing golang..."
curl -o "$LIBS"/go.tar.gz https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz
cd "$LIBS" && tar xzvf "$LIBS"/go.tar.gz && rm "${LIBS}"/go.tar.gz
GOROOT="$LIBS"/go

# install zsh and oh-my-zsh
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo 'execute pathogen#infect()' >> ~/.vimrc

# install vim-go
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

# write env variables
echo "export GOPATH=${GOPATH}" >> /etc/.zshrc
echo "export GOROOT=${GOROOT}" >> /etc/.zshrc
