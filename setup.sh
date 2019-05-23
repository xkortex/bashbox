#!/usr/bin/env bash

# install zsh
sudo apt-get install -y zsh

# Install oh my zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

source zsh/.zshrc

mkdir -p ${ZSH_CUSTOM}/plugins/
git clone https://github.com/larkery/zsh-histdb ${ZSH_CUSTOM}/plugins/zsh-histdb
