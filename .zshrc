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

if [ -e $HOME/nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
