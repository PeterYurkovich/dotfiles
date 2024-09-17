#!/usr/bin/env bash

declare -a individual_files=(".bash-preexec.sh", ".bashrc", ".commonrc", ".xonshrc", ".zprofile", ".zshrc", ".config/starship.toml")

for individual_file in "${individual_files[@]}"
do
	rm "~/${individual_file}"
done

declare -a folders=("xontrib", ".config/atuin", ".config/btop", ".config/kitty", ".config/nvim", ".config/tmux")

for folder in "${folders[@]}"
do
	rm -rf "~/${folder}"
done


