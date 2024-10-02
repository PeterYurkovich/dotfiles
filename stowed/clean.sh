#!/usr/bin/env bash

COMMAND="${COMMAND:-rm}"
FOLDER_COMMAND="${FOLDER_COMMAND:-rm -rf}"

declare -a individual_files=(".bash-preexec.sh" ".bashrc" ".commonrc" ".xonshrc" ".zprofile" ".zshrc" ".config/starship.toml" ".gitconfig")

for individual_file in "${individual_files[@]}"
do
	${COMMAND} ~/${individual_file}
done

declare -a folders=("xontrib" ".config/atuin" ".config/btop" ".config/kitty" ".config/nvim" ".config/tmux")

for folder in "${folders[@]}"
do
	${FOLDER_COMMAND} ~/${folder}
done


