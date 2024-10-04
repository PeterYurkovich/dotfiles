#!/usr/bin/env bash

# stow everything
stow --verbose --target=$HOME --restow atuin
stow --verbose --target=$HOME --restow bash
stow --verbose --target=$HOME --restow btop
stow --verbose --target=$HOME --restow common
stow --verbose --target=$HOME --restow git
stow --verbose --target=$HOME --restow kitty
stow --verbose --target=$HOME --restow nvim
stow --verbose --target=$HOME --restow starship
stow --verbose --target=$HOME --restow tmux
stow --verbose --target=$HOME --restow xonsh
stow --verbose --target=$HOME --restow zsh
