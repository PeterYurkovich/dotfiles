compinit

if [ -x "$(command -v atuin)" ]; then
  eval "$(atuin init zsh)"
fi

if [ -x "$(command -v starship)" ]; then
  eval "$(starship init zsh)"
fi

if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init zsh --cmd cd)"
fi

source $HOME/xontrib/rh_functions.sh
source $HOME/.commonrc
PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"


if [ -e $HOME/nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

. "$HOME/.atuin/bin/env"
