#!/usr/bin/env bash

python3 -m ensurepip
python3 -m pip install ansible
PATH="$HOME/.local/bin:$PATH"

ansible-playbook --ask-sudo-pass playbook.yaml

cd stowed
./stow_setup.sh
