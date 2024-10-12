# Configuration Files
My dotfile configuration setup. This is a major work in progress and requires a number of preinstalled applications, such as the xonsh shell and the awscli. Use these at your own risk

This repository now uses stow to symlink in all dotfiles due to difficulty in cloning down.

A pure `stow.sh` is provided to just stow the individual items, a `clean.sh` is used to clean out the old files, and a `setup.sh` is provided to tie them together.

## Installation
To install this repo, run the following command
```bash
curl https://raw.githubusercontent.com/peteryurkovich/dotfiles/main/prepare-development.sh | sh
```

## Packages
These are the common packages I use on my development systems. As of now, I am only concerned with my development environments, and not with anything else. There is potential for a reduced package set size for quick scaling in, but that is a future issue.

**Standard Packages**
- atuin
- awscli
- btop
- colima (for docker backend on mac)
- docker (cli only)
- docker-compose
- fzf
- gcc
- glab
- gnu-sed (mac only)
- helm
- jpeg-turbo
- jq
- kind
- kubernetes-cli
- kustomize
- lazygit
- lsd
- luajit
- neovim
- openshift-cli
- operator-sdk
- pipx (maybe)
- pixman (maybe)
- podman
- podman-compose
- pyenv
- python-jinja (mac only?)
- qemu (mac only)
- ripgrep
- starship
- stow
- tmux
- tree-sitter
- wget
- xonsh
- zoxide
- nvm
- python?
- kitty
- windows alternative for kitty? wsl config for kitty?
- nvim install plugins
- gitconfig update based on username of account? pyurkovi means redhat email while any other means peteryurkovich1@gmail.com
- 
