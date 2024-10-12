#!/usr/bin/env bash

python3 -m ensurepip
python3 -m pip install ansible
PATH="$HOME/.local/bin:$PATH"

ansible-playbook --ask-become-pass playbook.yaml

cd stowed
./stow_setup.sh

gh auth login
