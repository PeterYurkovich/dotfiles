if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

if [ -x "$(command -v atuin)" ]; then
  eval "$(atuin init bash)"
fi

if [ -x "$(command -v starship)" ]; then
  eval "$(starship init bash)"
fi

if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init bash --cmd cd)"
fi

source .commonrc