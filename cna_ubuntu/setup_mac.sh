#!/bin/bash


install_brew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_nvim() {
  brew install neovim
}

install_bash4() {
  brew update && brew install bash
}

install_ohmyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}
