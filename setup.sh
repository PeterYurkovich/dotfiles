#!/usr/bin/env bash

python3 -m ensurepip
python3 -m pip install ansible
PATH="$HOME/.local/bin:$PATH"

ansible-playbook --ask-become-pass playbook.yaml

cd stowed
./stow_setup.sh

cd ..
./atuin-installer.sh
rm -f atuin-installer.sh

gh auth login
mkdir $HOME/go
